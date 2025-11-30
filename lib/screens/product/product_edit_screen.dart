import 'package:flutter/material.dart';

class ProductEditScreen extends StatefulWidget {
  final Map<String, dynamic> product;   // ⬅️ Ubah ke MAP

  const ProductEditScreen({super.key, required this.product});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  late String harga;
  late String stok;

  @override
  void initState() {
    super.initState();
    harga = widget.product["price"].toString();
    stok = widget.product["stock"].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ---------------- HEADER ----------------
              Container(
                height: 100,
                padding: const EdgeInsets.only(top: 60, left: 18, right: 18),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 25,
                            color: Color(0xFF761B2D),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Edit Product',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF761B2D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              const SizedBox(height: 20),

              // ================= IMAGE =================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.product["image"] ?? "https://placehold.co/150",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20),

                  Container(
                    width: 180,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE5EB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Update Gambar",
                          style: TextStyle(
                            color: Color(0xFF630E2B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.image, size: 20, color: Color(0xFF630E2B)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              _buildStaticCard("Nama", widget.product["name"]),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => _editField("Harga", harga, (v) {
                  setState(() => harga = v);
                }),
                child: _buildStaticCard("Harga", harga),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => _editField("Stok", stok, (v) {
                  setState(() => stok = v);
                }),
                child: _buildStaticCard("Stok", stok),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      "price": harga,
                      "stock": stok,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB05478),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaticCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF630E2B),
        ),
      ),
    );
  }

  void _editField(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(
      text: currentValue,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Masukkan nilai baru"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
