import 'package:flutter/material.dart';
import 'product_add_screen.dart';
import 'product_edit_screen.dart';
import 'package:pos_app/services/product_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService service = ProductService();

  String selectedCategory = "All";
  String searchQuery = "";

  List<String> categories = ["All"];
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    final data = await service.getCategories();
    categories = ["All", ...data.map((e) => e["name"].toString())];
    setState(() {});
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    products = await service.getProducts();
    setState(() => isLoading = false);
  }

  List<Map<String, dynamic>> get filteredProducts {
    return products.where((p) {
      final cat = p["categories"]?["name"]?.toString() ?? "";
      final matchCat = selectedCategory == "All" || selectedCategory == cat;

      final matchSearch = p["name"]
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      return matchCat && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // SEARCH 
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7E5E8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search,
                              size: 24, color: Color(0xFF924A60)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search",
                              ),
                              onChanged: (v) =>
                                  setState(() => searchQuery = v),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // ADD 
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7A1A2F),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProductAddScreen(),
                          ),
                        );
                        if (result == true) fetchProducts();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              //CATEGORY 
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final c = categories[i];
                    final selected = selectedCategory == c;

                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF924A60)
                              : const Color(0xFFF8EDE6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          c,
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // PRODUCT GRID
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF924A60),
                        ),
                      )
                    : GridView.builder(
                        itemCount: filteredProducts.length,
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 225,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 18,
                        ),
                        itemBuilder: (_, i) =>
                            _buildProductCard(filteredProducts[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // PRODUCT 
  Widget _buildProductCard(Map<String, dynamic> p) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7E5E8),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ACTION BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  final update = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductEditScreen(product: p),
                    ),
                  );
                  if (update == true) fetchProducts();
                },
                child: const Icon(Icons.edit,
                    size: 18, color: Color(0xFF630E2B)),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showDeleteDialog(p["product_id"]),
                child: const Icon(Icons.delete_outline_outlined,
                    size: 18, color: Color(0xFF630E2B)),
              ),
            ],
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              p["image"] ?? "https://placehold.co/150x150",
              width: 115,
              height: 115,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            p["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF630E2B),
            ),
          ),

          Text(
            "Rp. ${p["price"]}",
            style: const TextStyle(fontSize: 14, color: Color(0xFF630E2B)),
          ),

          const Spacer(),

          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "Stok ${p["stock"]}",
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF630E2B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DELETE POPUP
  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 350,
          height: 196,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8E6C9),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Delete",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A2E2E),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "You are sure to delete \nthe product?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF6A2E2E)),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB57D7B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await service.deleteProduct(id);
                      Navigator.pop(context);
                      fetchProducts();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A1A2F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        const Text("Ok", style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
