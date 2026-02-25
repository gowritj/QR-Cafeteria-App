import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {

  static final _orders =
      FirebaseFirestore.instance.collection('orders');

  /* ===============================
      CREATE ORDER
  ===============================*/
  static Future<void> createOrder({
    required int table,
    required double total,
    required List<Map<String, dynamic>> items,
  }) async {

    await _orders.add({
      "table": table,
      "status": "Pending",
      "total": total,
      "timestamp": Timestamp.now(),
      "items": items,
    });
  }

  /* ===============================
      MARK ITEM PREPARED
  ===============================*/
  static Future<void> markItemPrepared({
    required String orderId,
    required int itemIndex,
  }) async {

    final doc = await _orders.doc(orderId).get();
    List items = doc['items'];

    items[itemIndex]['prepared'] = true;

    await _orders.doc(orderId).update({
      "items": items,
    });
  }

}