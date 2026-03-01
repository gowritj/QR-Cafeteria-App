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
  String searchText = "";
  String selectedFilter = "All";

  final TextEditingController _searchController = TextEditingController();

  /* ================= CATEGORY DATA ================= */

  final List<Map<String, dynamic>> categories = [
    {"title": "Biryani", "image": "assets/images/biriyani.jpg", "page": BiryaniListPage()},
    {"title": "Pizza", "image": "assets/images/pizza.jpg", "page": const PizzaListPage()},
    {"title": "Sandwich", "image": "assets/images/sandwich.jpg", "page": const SandwichListPage()},
    {"title": "Breads", "image": "assets/images/bread.jpg", "page": const BreadsListPage()},
    {"title": "Salads", "image": "assets/images/salads.jpg", "page": const SaladsListPage()},
    {"title": "Beverages", "image": "assets/images/beverages.jpg", "page": const BeveragesListPage()},
  ];

  final List<String> filters = [
    "All",
    "Biryani",
    "Pizza",
    "Sandwich",
    "Breads",
    "Salads",
    "Beverages",
  ];

  /* ================= FILTER LOGIC ================= */

  List<Map<String, dynamic>> get filteredCategories {
    return categories.where((cat) {
      final title = cat["title"].toString();
      final matchesSearch =
          title.toLowerCase().contains(searchText.toLowerCase());

      final matchesFilter =
          selectedFilter == "All" || title == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  /* ================= UI ================= */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      /* ================= APPBAR ================= */
      appBar: AppBar(
        title: Text("Menu • Table ${widget.tableId}"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(tableId: widget.tableId),
                    ),
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "0", // connect to cart count if available
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              )
            ],
          )
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          children: [

            /* ================= SEARCH ================= */
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 12,
                  )
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => searchText = v),
                decoration: InputDecoration(
                  hintText: "Search food category...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => searchText = "");
                          },
                        )
                      : null,
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            /* ================= HERO BANNER ================= */
            SizedBox(
              height: 150,
              child: PageView(
                children: [
                  _banner("Hot Deals 🔥", Colors.orange),
                  _banner("Buy 1 Get 1 🍕", Colors.redAccent),
                  _banner("Healthy Choices 🥗", Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /* ================= FILTER CHIPS ================= */
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, i) {
                  final label = filters[i];
                  final selected = selectedFilter == label;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => selectedFilter = label);
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            /* ================= CATEGORY GRID ================= */
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredCategories.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                final category = filteredCategories[index];

                return _CategoryCard(
                  title: category["title"],
                  image: category["image"],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => category["page"],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      /* ================= BOTTOM NAV ================= */
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
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /* ================= BANNER ================= */

  Widget _banner(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/* ================= CATEGORY CARD ================= */

class _CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.white,
        elevation: 6,
        borderRadius: BorderRadius.circular(22),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  title,
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
  }
}