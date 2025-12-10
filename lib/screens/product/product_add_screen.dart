import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
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
  final TextEditingController stockController = TextEditingController();

  String? nameError;
  String? priceError;
  String? stockError;
  String? categoryError;

  String? selectedCategoryId;
  List<Map<String, dynamic>> categories = [];

  File? selectedImage;
  Uint8List? webImageBytes;
  XFile? pickedImage;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();

    nameController.addListener(() {
      setState(() {
        nameError = nameController.text.trim().isEmpty
            ? "Nama produk wajib diisi"
            : null;
      });
    });

    priceController.addListener(() {
      final text = priceController.text.trim();
      if (text.isEmpty) {
        setState(() => priceError = "Harga wajib diisi");
      } else if (!RegExp(r'^\d+$').hasMatch(text)) {
        setState(() => priceError = "Hanya boleh angka");
      } else {
        setState(() => priceError = null);
      }
    });

    stockController.addListener(() {
      final text = stockController.text.trim();
      if (text.isEmpty) {
        setState(() => stockError = "Stok wajib diisi");
      } else if (!RegExp(r'^\d+$').hasMatch(text)) {
        setState(() => stockError = "Hanya boleh angka");
      } else {
        setState(() => stockError = null);
      }
    });
  }

  Future<void> fetchCategories() async {
    try {
      final data = await supabase.from('categories').select();
      if (!mounted) return;
      setState(() => categories = List<Map<String, dynamic>>.from(data));
    } catch (e) {
      print("Fetch categories error: $e");
    }
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
      if (!mounted) return;
      setState(() {});
    }
  }

  Future<String?> uploadImage() async {
    if (pickedImage == null) return null;

    try {
      final filePath =
          "uploads/product_${DateTime.now().millisecondsSinceEpoch}.jpg";

      if (kIsWeb) {
        final bytes = await pickedImage!.readAsBytes();
        await supabase.storage
            .from('product')
            .uploadBinary(
              filePath,
              bytes,
              fileOptions: const FileOptions(upsert: true),
            );
      } else {
        await supabase.storage
            .from('product')
            .upload(
              filePath,
              File(pickedImage!.path),
              fileOptions: const FileOptions(upsert: true),
            );
      }

      final url = supabase.storage.from('product').getPublicUrl(filePath);
      return url;
    } catch (e) {
      print("Upload Error: $e");
      return null;
    }
  }

  Future<void> saveProduct() async {
    
    setState(() {
      nameError = nameController.text.trim().isEmpty
          ? "Nama produk wajib diisi"
          : null;

      final priceText = priceController.text.trim();
      if (priceText.isEmpty) {
        priceError = "Harga wajib diisi";
      } else if (!RegExp(r'^\d+$').hasMatch(priceText)) {
        priceError = "Hanya boleh angka";
      } else {
        priceError = null;
      }

      final stockText = stockController.text.trim();
      if (stockText.isEmpty) {
        stockError = "Stok wajib diisi";
      } else if (!RegExp(r'^\d+$').hasMatch(stockText)) {
        stockError = "Hanya boleh angka";
      } else {
        stockError = null;
      }

      categoryError = selectedCategoryId == null
          ? "Kategori wajib dipilih"
          : null;
    });

    if (nameError != null ||
        priceError != null ||
        stockError != null ||
        categoryError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon lengkapi semua field dengan benar"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    String? imageUrl = await uploadImage();

    try {
      await supabase.from('products').insert({
        "name": nameController.text.trim(),
        "price": int.parse(priceController.text),
        "stock": int.parse(stockController.text),
        "category_id": int.parse(selectedCategoryId!),
        "image": imageUrl,
        "created_at": DateTime.now().toIso8601String(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print("Insert error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add product")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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
              // HEADER
              Container(
                height: 100,
                padding: const EdgeInsets.only(top: 60, left: 18, right: 18),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: Color(0xFF761B2D),
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

              // IMAGE PICKER
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
              const SizedBox(height: 40),

              _buildInput(nameController, "Name Product", errorText: nameError),
              const SizedBox(height: 20),

              _buildInput(
                priceController,
                "Price",
                errorText: priceError,
                isNumber: true,
              ),
              const SizedBox(height: 20),

              // CATEGORY
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedCategoryId,
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
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: categoryError != null
                              ? Colors.red
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: categoryError != null
                              ? Colors.red
                              : Colors.transparent,
                          width: 2,
                        ),
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
                    onChanged: (v) {
                      setState(() {
                        selectedCategoryId = v;
                        categoryError = null;
                      });
                    },
                  ),
                  if (categoryError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 10),
                      child: Text(
                        categoryError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              _buildInput(
                stockController,
                "Stock",
                errorText: stockError,
                isNumber: true,
              ),
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

  Widget _buildInput(
    TextEditingController controller,
    String placeholder, {
    String? errorText,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.transparent,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          style: const TextStyle(
            color: Color(0xFF761B2D),
            fontWeight: FontWeight.w600,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 10),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }
}
