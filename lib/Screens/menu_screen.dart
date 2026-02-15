import 'package:flutter/material.dart';
import 'package:module/items_list/beverages_list_page.dart';
import 'package:module/items_list/biriyani_list_page.dart';
import 'package:module/items_list/breads_list.dart';
import 'package:module/items_list/pizza_list_page.dart';
import 'package:module/items_list/salads_list_page.dart';
import 'package:module/items_list/sandwich_list_page.dart';

import 'package:module/Screens/cart_page.dart';
import 'package:module/Screens/profile_page.dart';

class MenuPage extends StatefulWidget {
  final String tableId;

  const MenuPage({super.key, required this.tableId});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _currentIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  String searchText = "";

  final List<Map<String, dynamic>> categories = [
    {
      "title": "Biryani",
      "image": "assets/images/biriyani.jpg",
      "page": BiryaniListPage(),
    },
    {
      "title": "Pizza",
      "image": "assets/images/pizza.jpg",
      "page": const PizzaListPage(),
    },
    {
      "title": "Sandwich",
      "image": "assets/images/sandwich.jpg",
      "page": const SandwichListPage(),
    },
    {
      "title": "Breads",
      "image": "assets/images/bread.jpg",
      "page": const BreadsListPage(),
    },
    {
      "title": "Salads",
      "image": "assets/images/salads.jpg",
      "page": const SaladsListPage(),
    },
    {
      "title": "Beverages",
      "image": "assets/images/beverages.jpg",
      "page": const BeveragesListPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCategories = categories.where((category) {
      final title = category["title"].toString().toLowerCase();
      return title.contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: Text("Menu | Table ${widget.tableId}"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔍 SEARCH BAR
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search category...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // GRID
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: filteredCategories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => category["page"] as Widget,
                        ),
                      );
                    },
                    child: Material(
                      color: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.black12,
                      borderRadius: BorderRadius.circular(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 7,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(22),
                              ),
                              child: Image.asset(
                                category["image"] as String,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                category["title"] as String,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        onTap: (index) {
          if (index == _currentIndex) return;

          setState(() => _currentIndex = index);

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CartPage(tableId: widget.tableId),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfilePage(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

