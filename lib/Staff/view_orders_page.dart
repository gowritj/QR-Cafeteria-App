import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewOrdersPage extends StatelessWidget {
  const ViewOrdersPage({super.key});

  Color statusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Preparing":
        return Colors.blue;
      case "Ready":
        return Colors.green;
      case "Served":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Live Orders"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),

      // REALTIME STREAM
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(child: Text("No orders yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final doc = orders[index];
              final data = doc.data() as Map<String, dynamic>;

              final table = data["table"];
              final status = data["status"] ?? "Pending";

              final items = List<Map<String, dynamic>>.from(
                data["items"] ?? [],
              );

              return _OrderCard(
                docId: doc.id,
                table: table.toString(),
                status: status,
                items: items,
              );
            },
          );
        },
      ),
    );
  }
}

/* =====================================================
   ORDER CARD
=====================================================*/
class _OrderCard extends StatelessWidget {
  final String docId;
  final String table;
  final String status;
  final List<Map<String, dynamic>> items;

  const _OrderCard({
    required this.docId,
    required this.table,
    required this.status,
    required this.items,
  });

  Color statusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Preparing":
        return Colors.blue;
      case "Ready":
        return Colors.green;
      case "Served":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  /* ================================
      MARK ITEM PREPARED
  ================================*/
  Future<void> markPrepared(int index) async {
    final ref = FirebaseFirestore.instance.collection("orders").doc(docId);

    final doc = await ref.get();
    List items = doc["items"];

    items[index]["prepared"] = true;

    await ref.update({"items": items});
  }

  /* ================================
      UPDATE ORDER STATUS
  ================================*/
  Future<void> updateStatus() async {
    final next = {
      "Pending": "Preparing",
      "Preparing": "Ready",
      "Ready": "Served",
      "Served": "Served",
    };

    await FirebaseFirestore.instance.collection("orders").doc(docId).update({
      "status": next[status],
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: updateStatus, // tap card → next status
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* TABLE + STATUS */
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Table $table",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Chip(
                  label: Text(status),
                  backgroundColor: statusColor(status).withAlpha(51),
                  labelStyle: TextStyle(color: statusColor(status)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /* ITEMS LIST */
            ...List.generate(items.length, (i) {
              final item = items[i];
              final prepared = item["prepared"] ?? false;

              return Row(
                children: [
                  Icon(
                    prepared
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: prepared ? Colors.green : Colors.red,
                  ),

                  const SizedBox(width: 6),

                  Text("${item["name"]} x${item["qty"]}"),

                  const Spacer(),

                  if (!prepared)
                    IconButton(
                      icon: const Icon(Icons.done),
                      onPressed: () => markPrepared(i),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
