import 'package:flutter/material.dart';
import 'package:pharmacy_management/core/theme/app_theme.dart';
import 'package:pharmacy_management/features/order/domain/entities/order.dart';

class OrderTable extends StatefulWidget {
  final List<Order> orders;
  final Function(Order) onEdit;
  final Function(Order, String) onUpdateStatus;

  const OrderTable({
    super.key,
    required this.orders,
    required this.onEdit,
    required this.onUpdateStatus,
  });

  @override
  _OrderTableState createState() => _OrderTableState();
}

class _OrderTableState extends State<OrderTable> {
  List<Order> filteredOrders = [];
  TextEditingController searchController = TextEditingController();
  int _currentPage = 1;
  int _entriesPerPage = 10;
  final List<int> _entriesPerPageOptions = [10, 20, 50];

  @override
  void initState() {
    super.initState();
    _loadOrders();
    searchController.addListener(() {
      _filterOrders(searchController.text);
    });
  }

  @override
  void didUpdateWidget(OrderTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.orders != oldWidget.orders) {
      _loadOrders();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _loadOrders() {
    setState(() {
      filteredOrders = List.from(widget.orders);
      _filterOrders(searchController.text);
    });
  }

  void _filterOrders(String query) {
    setState(() {
      List<Order> tempFiltered = List.from(widget.orders);

      if (query.isNotEmpty) {
        tempFiltered = tempFiltered.where((order) {
          return order.customerName.toLowerCase().contains(query.toLowerCase()) ||
              order.medicineId.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }

      filteredOrders = tempFiltered;
      _currentPage = 1;
    });
  }

  void _resetFilters() {
    setState(() {
      searchController.clear();
      filteredOrders = List.from(widget.orders);
      _currentPage = 1;
    });
  }

  List<Order> _getPaginatedOrders() {
    int startIndex = (_currentPage - 1) * _entriesPerPage;
    int endIndex = startIndex + _entriesPerPage;
    if (endIndex > filteredOrders.length) {
      endIndex = filteredOrders.length;
    }
    return filteredOrders.sublist(startIndex, endIndex);
  }

  void _nextPage() {
    if (_currentPage < (filteredOrders.length / _entriesPerPage).ceil()) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState() {
        _currentPage--;
      };
  }
  }

  Future<void> _handleEdit(Order order) async {
    TextEditingController customerNameController = TextEditingController(text: order.customerName);
    TextEditingController medicineIdController = TextEditingController(text: order.medicineId);
    TextEditingController quantityController = TextEditingController(text: order.quantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Edit Order',
            style: TextStyle(color: AppTheme.charcoal, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: customerNameController,
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    prefixIcon: Icon(Icons.person, color: AppTheme.charcoal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: AppTheme.grey.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: AppTheme.oliveGreen, width: 2),
                    ),
                    filled: true,
                    fillColor: AppTheme.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  style: const TextStyle(color: AppTheme.charcoal),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: medicineIdController,
                  decoration: InputDecoration(
                    labelText: 'Medicine ID',
                    prefixIcon: Icon(Icons.medical_services, color: AppTheme.charcoal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: AppTheme.grey.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: AppTheme.oliveGreen, width: 2),
                    ),
                    filled: true,
                    fillColor: AppTheme.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  style: const TextStyle(color: AppTheme.charcoal),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    prefixIcon: Icon(Icons.inventory, color: AppTheme.charcoal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: AppTheme.grey.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: AppTheme.oliveGreen, width: 2),
                    ),
                    filled: true,
                    fillColor: AppTheme.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  style: const TextStyle(color: AppTheme.charcoal),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppTheme.charcoal)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.oliveGreen, Color(0xFF388E3C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  final updatedOrder = Order(
                    id: order.id,
                    medicineId: medicineIdController.text,
                    customerName: customerNameController.text,
                    quantity: int.tryParse(quantityController.text) ?? 0,
                    status: order.status,
                  );
                  widget.onEdit(updatedOrder);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final textStyle = TextStyle(
      color: isDarkMode ? AppTheme.white : AppTheme.charcoal,
      fontSize: isMobile ? 14 : 16,
      fontWeight: FontWeight.w500,
    );
    final headerStyle = TextStyle(
      color: isDarkMode ? AppTheme.white : AppTheme.charcoal,
      fontSize: isMobile ? 12 : 14,
      fontWeight: FontWeight.w600,
    );
    final dropdownFillColor = isDarkMode ? AppTheme.cardBackgroundDark : AppTheme.white;
    final textFieldBorderColor = isDarkMode ? AppTheme.grey.withOpacity(0.7) : AppTheme.grey.withOpacity(0.3);

    final paginatedOrders = _getPaginatedOrders();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16.0),
          Container(
            width: isMobile ? MediaQuery.of(context).size.width * 0.9 : MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.cardBackgroundDark : AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(isDarkMode ? 0.5 : 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isDarkMode ? AppTheme.grey.withOpacity(0.5) : AppTheme.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Order List',
                  style: TextStyle(
                    fontSize: isMobile ? 22 : 28,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppTheme.white : AppTheme.charcoal,
                  ),
                ),
                const SizedBox(height: 16.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: isMobile
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: TextField(
                          controller: searchController,
                          style: TextStyle(color: isDarkMode ? AppTheme.white : AppTheme.charcoal),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: isDarkMode ? AppTheme.grey.withOpacity(0.6) : AppTheme.grey),
                            prefixIcon: Icon(Icons.search, color: isDarkMode ? AppTheme.white : AppTheme.charcoal, size: 18),
                            filled: true,
                            fillColor: dropdownFillColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: textFieldBorderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: textFieldBorderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: AppTheme.oliveGreen, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextField(
                          controller: searchController,
                          style: TextStyle(color: isDarkMode ? AppTheme.white : AppTheme.charcoal),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: isDarkMode ? AppTheme.grey.withOpacity(0.6) : AppTheme.grey),
                            prefixIcon: Icon(Icons.search, color: isDarkMode ? AppTheme.white : AppTheme.charcoal, size: 18),
                            filled: true,
                            fillColor: dropdownFillColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: textFieldBorderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: textFieldBorderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: AppTheme.oliveGreen, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16.0,
                    headingRowHeight: 40,
                    headingRowColor: MaterialStateProperty.all(isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFF5F7FA)),
                    dataRowHeight: 48,
                    dividerThickness: 0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDarkMode ? AppTheme.grey.withOpacity(0.3) : AppTheme.grey.withOpacity(0.2),
                        ),
                      ),
                    ),
                    columns: [
                      DataColumn(label: Text('Customer Name', style: headerStyle)),
                      DataColumn(label: Text('Medicine ID', style: headerStyle)),
                      DataColumn(label: Text('Quantity', style: headerStyle)),
                      DataColumn(label: Text('Status', style: headerStyle)),
                      DataColumn(label: Text('Actions', style: headerStyle)),
                    ],
                    rows: paginatedOrders.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final Order order = entry.value;
                      return DataRow(
                        color: MaterialStateProperty.all(
                          index % 2 == 0
                              ? (isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF))
                              : (isDarkMode ? const Color(0xFF252525) : const Color(0xFFF9FAFB)),
                        ),
                        cells: [
                          DataCell(Text(order.customerName ?? '', style: textStyle)),
                          DataCell(Text(order.medicineId ?? '', style: textStyle)),
                          DataCell(Text(order.quantity.toString(), style: textStyle)),
                          DataCell(
                            DropdownButton<String>(
                              value: order.status,
                              items: ['Pending', 'Confirmed', 'Delivered']
                                  .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status, style: textStyle),
                              ))
                                  .toList(),
                              onChanged: (newStatus) {
                                if (newStatus != null) {
                                  widget.onUpdateStatus(order, newStatus);
                                }
                              },
                              dropdownColor: dropdownFillColor,
                              style: textStyle,
                              underline: Container(
                                height: 2,
                                color: AppTheme.oliveGreen,
                              ),
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppTheme.oliveGreen, size: 20),
                              onPressed: () => _handleEdit(order),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('Rows per page:', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _entriesPerPage,
                          items: _entriesPerPageOptions.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString(), style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _entriesPerPage = newValue;
                                _currentPage = 1;
                              });
                            }
                          },
                          dropdownColor: dropdownFillColor,
                          style: textStyle,
                          underline: Container(
                            height: 2,
                            color: AppTheme.oliveGreen,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Page $_currentPage of ${(filteredOrders.length / _entriesPerPage).ceil()}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, size: 20),
                          onPressed: _previousPage,
                          color: _currentPage == 1 ? AppTheme.grey : AppTheme.charcoal,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, size: 20),
                          onPressed: _nextPage,
                          color: _currentPage == (filteredOrders.length / _entriesPerPage).ceil() ? AppTheme.grey : AppTheme.charcoal,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}