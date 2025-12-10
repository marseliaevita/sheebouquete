import 'package:flutter/material.dart';
import 'package:pos_app/widgets/card_customer.dart';
import 'package:pos_app/services/customer_service.dart';
import 'package:pos_app/screens/customer/customer_history_screen.dart';
import 'package:pos_app/screens/customer/customer_popup.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final TextEditingController searchController = TextEditingController();
  final CustomerService customerService = CustomerService();

  List<Map<String, dynamic>> customers = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchCustomers();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchCustomers() async {
    setState(() => isLoading = true);
    try {
      final data = await customerService.getCustomers();
      setState(() {
        customers = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetch customers: $e");
      setState(() => isLoading = false);
    }
  }

  // DIALOG DELETE
  void _showDeleteDialog(int customerId, String customerName) {
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
              Center(
                child: Text(
                  "You are sure to delete\n\"$customerName\"?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6A2E2E),
                  ),
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
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        await customerService.deleteCustomerWithOrders(
                          customerId: customerId,
                        );

                        if (!mounted) return;
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$customerName berhasil dihapus'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        fetchCustomers();
                      } catch (e) {
                        if (!mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Gagal menghapus customer'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A1A2F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Ok",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCustomers = customers.where((c) {
      final name = c['name']?.toString().toLowerCase() ?? '';
      return name.contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SEARCH BOX + ADD BUTTON
              Row(
                children: [
                  Container(
                    height: 78,
                    width: 306,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7E5E8),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          size: 24,
                          color: Color(0xFF924A60),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => AddCustomerPopup(
                          onAdded: () async {
                            await fetchCustomers();
                            setState(() {});
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 76,
                      width: 76,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0E2D5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.group, color: Color(0xFF8A0B38)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // CUSTOMER LIST
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredCustomers.isEmpty
                    ? const Center(child: Text("No customers found"))
                    : ListView.builder(
                        itemCount: filteredCustomers.length,
                        itemBuilder: (context, index) {
                          final c = filteredCustomers[index];

                          return CardCustomer(
                            name: c['name'] ?? '-',
                            orders: c['orders'] ?? 0,
                            totalSpent: c['total_spent'] ?? 0,

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CustomerHistoryScreen(
                                    customer: {
                                      "name": c['name'],
                                      "phone": c['phone'] ?? "-",
                                      "address": c['address'] ?? '-',
                                    },
                                  ),
                                ),
                              );
                            },

                            onEdit: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => EditCustomerPopup(
                                  customer: c,
                                  onUpdated: fetchCustomers,
                                ),
                              );
                            },

                            onDelete: () {
                              _showDeleteDialog(
                                c['customer_id'] as int,
                                c['name'] ?? 'Customer',
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
