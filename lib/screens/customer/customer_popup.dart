import 'package:flutter/material.dart';
import 'package:pos_app/services/customer_service.dart';

class EditCustomerPopup extends StatefulWidget {
  final Map<String, dynamic> customer;
  final VoidCallback onUpdated;

  const EditCustomerPopup({
    super.key,
    required this.customer,
    required this.onUpdated,
  });

  @override
  State<EditCustomerPopup> createState() => _EditCustomerPopupState();
}

class _EditCustomerPopupState extends State<EditCustomerPopup> {
  final CustomerService service = CustomerService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? nameError;
  String? phoneError;
  String? addressError;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.customer['name'] ?? "";
    phoneController.text = widget.customer['phone'] ?? "";
    addressController.text = widget.customer['address'] ?? "";

    nameController.addListener(_validateName);
    phoneController.addListener(_validatePhone);
    addressController.addListener(_validateAddress);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateName();
      _validatePhone();
      _validateAddress();
    });
  }

  void _validateName() {
    setState(() {
      nameError = nameController.text.trim().isEmpty ? "Nama wajib diisi" : null;
    });
  }

  void _validatePhone() {
    final text = phoneController.text.trim();
    setState(() {
      if (text.isEmpty) {
        phoneError = "Nomor telepon wajib diisi";
      } else if (!RegExp(r'^\d+$').hasMatch(text)) {
        phoneError = "Hanya boleh angka";
      } else {
        phoneError = null;
      }
    });
  }

  void _validateAddress() {
    setState(() {
      addressError = addressController.text.trim().isEmpty ? "Alamat wajib diisi" : null;
    });
  }

  Future<void> _saveCustomer() async {
    _validateName();
    _validatePhone();
    _validateAddress();

    if (nameError != null || phoneError != null || addressError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon lengkapi semua field dengan benar"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await service.updateCustomer(
        customerId: widget.customer['customer_id'],
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
      );

      widget.onUpdated();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update customer: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Color(0xFF761B2D), width: 3),
      ),
      child: SizedBox(
        width: 357,
        height: 600,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  const Text(
                    "Edit Customer",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF8A0B38)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Color(0xFF8A0B38), size: 26),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              //PROFILE  
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
                alignment: Alignment.center,
                child: Text(
                  (widget.customer['name'] as String?)?.isNotEmpty == true
                      ? widget.customer['name'][0].toUpperCase()
                      : "?",
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF8A0B38)),
                ),
              ),

              const SizedBox(height: 34),

              // INPUT NAMA
              _buildInput(controller: nameController, hint: "Nama", errorText: nameError),

              const SizedBox(height: 35),

              // INPUT TELEPON
              _buildInput(
                controller: phoneController,
                hint: "Telepon",
                keyboard: TextInputType.phone,
                errorText: phoneError,
              ),

              const SizedBox(height: 35),

              // INPUT ALAMAT 
              _buildInput(
                controller: addressController,
                hint: "Alamat",
                keyboard: TextInputType.streetAddress,
                errorText: addressError,
              ),

              const Spacer(),

              // SAVE BUTTON
              GestureDetector(
                onTap: _saveCustomer,
                child: Container(
                  height: 48,
                  width: 140,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 216, 78, 127),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFF6DCE2),
            borderRadius: BorderRadius.circular(25),
            border: errorText != null ? Border.all(color: Colors.red, width: 2) : null,
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboard,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              hintStyle: const TextStyle(color: Color(0xFF8A0B38)),
            ),
            style: const TextStyle(color: Color(0xFF8A0B38)),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 10),
            child: Text(errorText, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}


// ADD CUSTOMER POPUP
class AddCustomerPopup extends StatefulWidget {
  final VoidCallback onAdded;

  const AddCustomerPopup({
    super.key,
    required this.onAdded,
  });

  @override
  State<AddCustomerPopup> createState() => _AddCustomerPopupState();
}

class _AddCustomerPopupState extends State<AddCustomerPopup> {
  final CustomerService service = CustomerService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
String? addressError;

  String? nameError;
  String? phoneError;

@override
void initState() {
  super.initState();

  nameController.addListener(_validateName);
  phoneController.addListener(_validatePhone);
  addressController.addListener(_validateAddress); 

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _validateName();
    _validatePhone();
    _validateAddress();
  });
}

void _validateName() {
  setState(() {
    nameError = nameController.text.trim().isEmpty ? "Nama wajib diisi" : null;
  });
}

void _validatePhone() {
  final text = phoneController.text.trim();
  setState(() {
    if (text.isEmpty) {
      phoneError = "Nomor telepon wajib diisi";
    } else if (!RegExp(r'^\d+$').hasMatch(text)) {
      phoneError = "Hanya boleh angka";
    } else {
      phoneError = null;
    }
  });
}

void _validateAddress() {
  setState(() {
    addressError = addressController.text.trim().isEmpty ? "Alamat wajib diisi" : null;
  });
}

  

  Future<void> _saveCustomer() async {
    setState(() {
      nameError = nameController.text.trim().isEmpty
          ? "Nama wajib diisi"
          : null;

      final phoneText = phoneController.text.trim();
      if (phoneText.isEmpty) {
        phoneError = "Nomor telepon wajib diisi";
      } else if (!RegExp(r'^\d+$').hasMatch(phoneText)) {
        phoneError = "Hanya boleh angka";
      } else {
        phoneError = null;
      }
    });

    if (nameError != null || phoneError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon lengkapi semua field dengan benar"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await service.addCustomer(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
      );

      widget.onAdded();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambah customer: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(
          color: Color(0xFF761B2D),
          width: 3,
        ),
      ),
      child: SizedBox(
        width: 357,
        height: 600,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  const Text(
                    "Add Customer",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8A0B38),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF8A0B38),
                      size: 26,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 45),

              // INPUT NAME
              _buildInput(
                controller: nameController,
                hint: "Name",
                errorText: nameError,
              ),

              const SizedBox(height: 40),

              // INPUT PHONE
              _buildInput(
                controller: phoneController,
                hint: "Telephone",
                keyboard: TextInputType.phone,
                errorText: phoneError,
              ),

              const SizedBox(height: 40),

              _buildInput(
  controller: addressController,
  hint: "Alamat",
  keyboard: TextInputType.streetAddress,
  errorText: addressError,
),

const SizedBox(height: 70),

              // SAVE BUTTON
              GestureDetector(
                onTap: _saveCustomer,
                child: Container(
                  height: 48,
                  width: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A0B38),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFF6DCE2),
            borderRadius: BorderRadius.circular(25),
            border: errorText != null
                ? Border.all(color: Colors.red, width: 2)
                : null,
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboard,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              hintStyle: const TextStyle(color: Color(0xFF8A0B38)),
            ),
            style: const TextStyle(color: Color(0xFF8A0B38)),
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
    phoneController.dispose();
    super.dispose();
  }
}