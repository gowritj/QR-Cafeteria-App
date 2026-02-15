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

  /* =========================================================
     ADD STAFF
  =========================================================*/
  Future<void> addStaff() async {
    if (nameController.text.isEmpty || roleController.text.isEmpty) return;

    await staffRef.add({
      "name": nameController.text,
      "role": roleController.text,
      "createdAt": Timestamp.now(),
    });

    nameController.clear();
    roleController.clear();
  }

  /* =========================================================
     UI
  =========================================================*/
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
        children: [
          staffTab(),
          ordersTab(),
          salesTab(),
        ],
      ),
    );
  }

  /* =========================================================
     STAFF TAB
  =========================================================*/
  Widget staffTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          const Text("Add Staff"),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),

          TextField(
            controller: roleController,
            decoration: const InputDecoration(labelText: "Role"),
          ),

          ElevatedButton(
            onPressed: addStaff,
            child: const Text("Add"),
          ),

          const Divider(),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: staffRef.snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {

                    final d = docs[i];

                    return ListTile(
                      title: Text(d["name"]),
                      subtitle: Text(d["role"]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => staffRef.doc(d.id).delete(),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  /* =========================================================
     ORDERS TAB (LIVE)
  =========================================================*/
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
            final items =
                List<Map<String, dynamic>>.from(o["items"] ?? []);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Table ${o["table"]}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),

                    const SizedBox(height: 5),

                    ...items.map((e) =>
                        Text("${e["name"]} x${e["qty"]}")),

                    Text("Total ₹${o["total"]}"),

                    DropdownButton<String>(
                      value: o["status"],
                      items: statusList
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s),
                              ))
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

  /* =========================================================
     SALES TAB
  =========================================================*/
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
                child: ListTile(
                  title: const Text("Orders Today"),
                  trailing: Text(orderCount.toString()),
                ),
              ),

              Card(
                child: ListTile(
                  title: const Text("Revenue Today"),
                  trailing: Text("₹${revenue.toStringAsFixed(0)}"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
