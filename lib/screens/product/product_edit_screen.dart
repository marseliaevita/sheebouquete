import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/services/product_service.dart';

class ProductEditScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductEditScreen({super.key, required this.product});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;

  XFile? pickedImage;
  Uint8List? webImageBytes;
  File? selectedImage;

  String? nameError;     
  String? priceError;
  String? stockError;

  bool isLoading = false;

  final ProductService service = ProductService();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.product["name"] ?? "");
    priceController =
        TextEditingController(text: widget.product["price"].toString());
    stockController =
        TextEditingController(text: widget.product["stock"].toString());

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.notifyListeners();
      priceController.notifyListeners();
      stockController.notifyListeners();
    });
  }

  Future<void> pickImageFromGallery() async {
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

  Future<void> saveProduct() async {
    setState(() {
      nameError = nameController.text.trim().isEmpty ? "Nama produk wajib diisi" : null;
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
    });

    if (nameError != null || priceError != null || stockError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon lengkapi semua field dengan benar")),
      );
      return;
    }

    setState(() => isLoading = true);

    String? uploadedUrl;
    if (pickedImage != null) {
      uploadedUrl = await service.uploadImage(pickedImage!);
    }

    try {
      await service.updateProduct(
        productId: widget.product["product_id"],
        name: nameController.text.trim(),
        price: int.parse(priceController.text),
        stock: int.parse(stockController.text),
        imageUrl: uploadedUrl ?? widget.product["image"],
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product updated successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print("Update Error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update product")),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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
              // HEADER 
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

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: kIsWeb && webImageBytes != null
                        ? Image.memory(
                            webImageBytes!,
                            width: 186,
                            height: 186,
                            fit: BoxFit.cover,
                          )
                        : (selectedImage != null
                            ? Image.file(
                                selectedImage!,
                                width: 186,
                                height: 186,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                widget.product["image"] ??
                                    "https://via.placeholder.com/150",
                                width: 186,
                                height: 186,
                                fit: BoxFit.cover,
                              )),
                  ),
                  const SizedBox(width: 20),

                  // BUTTON 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 186,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: pickImageFromGallery,
                            child: Container(
                              width: 172,
                              height: 54,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE5EB),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
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
                                  Icon(
                                    Icons.image,
                                    size: 20,
                                    color: Color(0xFF630E2B),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // INPUT
              _buildInput(nameController, "Name Product", errorText: nameError),
              const SizedBox(height: 30),
              _buildInput(priceController, "Price",
                  errorText: priceError, isNumber: true),
              const SizedBox(height: 30),
              _buildInput(stockController, "Stock",
                  errorText: stockError, isNumber: true),
              const SizedBox(height: 70),

              // SAVE 
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB05478),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
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

  Widget _buildInput(TextEditingController controller, String label,
      {String? errorText, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFEDE5EB),
            hintText: label,
            hintStyle: const TextStyle(color: Color(0xFF761B2D)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.transparent,
                  width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.transparent,
                  width: 2),
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