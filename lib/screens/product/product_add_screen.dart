import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final supabase = Supabase.instance.client;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  File? selectedImage; // untuk mobile/desktop
  Uint8List? webImageBytes; // untuk web
  XFile? pickedImage; // XFile dari picker
  List<Map<String, dynamic>> categories = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final data = await supabase.from('categories').select();
    setState(() => categories = List<Map<String, dynamic>>.from(data));
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      pickedImage = img;
      if (kIsWeb) {
        webImageBytes = await img.readAsBytes();
      } else {
        selectedImage = File(img.path);
      }
      setState(() {});
    }
  }

  Future<String?> uploadImage() async {
    if (pickedImage == null) return null;

    try {
      final filePath = "product_${DateTime.now().millisecondsSinceEpoch}.jpg";

      if (kIsWeb) {
        final bytes = await pickedImage!.readAsBytes();
        await supabase.storage
            .from('product')
            .uploadBinary(
              filePath,
              bytes,
              fileOptions: FileOptions(upsert: true),
            );
      } else {
        final file = File(pickedImage!.path);
        await supabase.storage
            .from('product')
            .upload(filePath, file, fileOptions: FileOptions(upsert: true));
      }

      // Langsung dapatkan URL sebagai String
      final imageUrl = supabase.storage.from('product').getPublicUrl(filePath);
      return imageUrl;
    } catch (e) {
      print("Upload Error: $e");
      return null;
    }
  }

  Future<void> saveProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        categoryController.text.isEmpty ||
        stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    // Upload Image
    String? imageUrl = await uploadImage();

    try {
      await supabase.from('products').insert({
        "name": nameController.text,
        "price": int.parse(priceController.text),
        "category_id": int.parse(categoryController.text),
        "stock": int.parse(stockController.text),
        "image": imageUrl, // ✅ URL gambar tersimpan
        "created_at": DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print("Insert error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add product")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
                      'Add Product',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF761B2D),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // IMAGE UPLOAD BOX
              Row(
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: 187,
                      height: 186,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE5EB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: pickedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.image,
                                  size: 45,
                                  color: Color(0xFF761B2D),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Upload Image",
                                  style: TextStyle(
                                    color: Color(0xFF761B2D),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: kIsWeb && webImageBytes != null
                                  ? Image.memory(
                                      webImageBytes!,
                                      width: 187,
                                      height: 186,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      selectedImage!,
                                      width: 187,
                                      height: 186,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // FORM
              _buildInput(nameController, "Name Product:"),
              const SizedBox(height: 20),

              _buildInput(priceController, "Price:"),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF3D5E0),
                  hintText: "Category:",
                  hintStyle: const TextStyle(color: Color(0xFF761B2D)),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c['category_id'].toString(),
                        child: Text(c['name']),
                      ),
                    )
                    .toList(),
                onChanged: (v) => categoryController.text = v!,
              ),

              const SizedBox(height: 20),

              _buildInput(stockController, "Stock:"),
              const SizedBox(height: 40),

              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB05478),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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

  Widget _buildInput(TextEditingController controller, String placeholder) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3D5E0),
        hintText: placeholder,
        hintStyle: const TextStyle(color: Color(0xFF761B2D)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(
        color: Color(0xFF761B2D),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
