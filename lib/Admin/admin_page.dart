import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final staffRef = FirebaseFirestore.instance.collection("staff");
  final orderRef = FirebaseFirestore.instance.collection("orders");

  final nameController = TextEditingController();
  final roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  /* ================================
      ADD STAFF
  ================================*/
  Future<void> addStaff() async {
    if (nameController.text.isEmpty || roleController.text.isEmpty) return;

    await staffRef.add({
      "name": nameController.text,
      "role": roleController.text,
      "createdAt": Timestamp.now(),
    });

    nameController.clear();
    roleController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Staff added")));
  }

  /* ================================
      STATUS COLOR
  ================================*/
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
      UI
  ================================*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: "Staff"),
            Tab(text: "Orders"),
            Tab(text: "Sales"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [staffTab(), ordersTab(), salesTab()],
      ),
    );
  }

  /* ================================
      STAFF TAB
  ================================*/
  Widget staffTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("Add Staff", style: TextStyle(fontSize: 18)),

          const SizedBox(height: 10),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: roleController,
            decoration: const InputDecoration(
              labelText: "Role",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(onPressed: addStaff, child: const Text("Add Staff")),

          const Divider(height: 30),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: staffRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: snapshot.data!.docs.map((d) {
                    return Card(
                      child: ListTile(
                        title: Text(d["name"]),
                        subtitle: Text(d["role"]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => staffRef.doc(d.id).delete(),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /* ================================
      ORDERS TAB — PROFESSIONAL
  ================================*/
  Widget ordersTab() {
    const statusList = ["Pending", "Preparing", "Ready", "Served"];

    return StreamBuilder<QuerySnapshot>(
      stream: orderRef.orderBy("timestamp", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, i) {
            final o = orders[i];
            final data = o.data() as Map<String, dynamic>;

            final items = List<Map<String, dynamic>>.from(data["items"] ?? []);

            /* ===============================
             SAFE STATUS FIX
          ===============================*/
            String status = data["status"] ?? "Pending";

            // normalize text (pending → Pending)
            status = status.toString().trim();
            status = status.isEmpty
                ? "Pending"
                : status[0].toUpperCase() + status.substring(1).toLowerCase();

            // ensure dropdown has matching value
            if (!statusList.contains(status)) {
              status = "Pending";
            }

            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Table ${data["table"]}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Chip(
                          label: Text(status),
                          backgroundColor: statusColor(status),
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    ...items.map((e) {
                      final prepared = e["prepared"] ?? false;

                      return Row(
                        children: [
                          Icon(
                            prepared
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: prepared ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 6),
                          Text("${e["name"]} x${e["qty"]}"),
                        ],
                      );
                    }),

                    const SizedBox(height: 8),

                    Text(
                      "Total ₹${data["total"]}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    DropdownButton<String>(
                      value: status,
                      isExpanded: true,
                      items: statusList
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (value) {
                        orderRef.doc(o.id).update({"status": value});
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /* ================================
      SALES TAB
  ================================*/
  Widget salesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: orderRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final now = DateTime.now();
        double revenue = 0;
        int orderCount = 0;

        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;

          final tsField = data["timestamp"];
          if (tsField is! Timestamp) continue;

          final ts = tsField.toDate();

          if (ts.year == now.year &&
              ts.month == now.month &&
              ts.day == now.day) {
            revenue += (data["total"] ?? 0).toDouble();
            orderCount++;
          }
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                elevation: 3,
                child: ListTile(
                  title: const Text("Orders Today"),
                  trailing: Text(
                    orderCount.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Card(
                elevation: 3,
                child: ListTile(
                  title: const Text("Revenue Today"),
                  trailing: Text(
                    "₹${revenue.toStringAsFixed(0)}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
