import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewOrdersPage extends StatelessWidget {
  const ViewOrdersPage({super.key});

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

      // 🔥 REALTIME FIRESTORE STREAM
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .orderBy("createdAt", descending: true)
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

              final table = data["tableId"];
              final status = data["status"];
              final items = (data["items"] ?? []) as List;


              // convert items to display text
              final itemText = items
                  .map((e) => "${e["name"]} x${e["quantity"]}")
                  .join(", ");

              return _OrderCard(
                docId: doc.id,
                table: table,
                items: itemText,
                status: status,
              );
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String docId;
  final String table;
  final String items;
  final String status;

  const _OrderCard({
    required this.docId,
    required this.table,
    required this.items,
    required this.status,
  });

  // 🔄 UPDATE STATUS
  Future<void> updateStatus() async {
    final newStatus = status == "Preparing" ? "Prepared" : "Completed";

    await FirebaseFirestore.instance
        .collection("orders")
        .doc(docId)
        .update({"status": newStatus});
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (status == "Preparing") {
      statusColor = Colors.orange;
    } else if (status == "Prepared") {
      statusColor = Colors.green;
    } else {
      statusColor = Colors.blue;
    }

    return GestureDetector(
      onTap: updateStatus,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              table,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(items),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: Chip(
                label: Text(status),
                backgroundColor: statusColor.withOpacity(0.2),
                labelStyle: TextStyle(color: statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
