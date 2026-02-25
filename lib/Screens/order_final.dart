import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistoryPage extends StatelessWidget {
  final String tableId;

  const OrderHistoryPage({super.key, required this.tableId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Your Orders"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("tableId", isEqualTo: tableId) // ✅ NO orderBy (no index needed)
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No orders yet",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {

              final data =
                  orders[index].data() as Map<String, dynamic>;

              final List items =
                  data["items"] ?? [];

              final status =
                  data["status"] ?? "Pending";

              final total =
                  data["total"] ?? 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // STATUS
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Order",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold),
                        ),
                        Chip(
                          label: Text(status),
                          backgroundColor:
                              _statusColor(status)
                                  .withOpacity(0.2),
                          labelStyle: TextStyle(
                              color:
                                  _statusColor(status)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // ITEMS
                    ...items.map((item) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(
                                bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              item["prepared"] ==
                                      true
                                  ? Icons
                                      .check_circle
                                  : Icons
                                      .access_time,
                              size: 16,
                              color: item[
                                          "prepared"] ==
                                      true
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                                "${item["name"]} x${item["qty"]}"),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 8),

                    // TOTAL
                    Text(
                      "Total ₹$total",
                      style: const TextStyle(
                          fontWeight:
                              FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Preparing":
        return Colors.blue;
      case "Ready":
        return Colors.green;
      case "Completed":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}