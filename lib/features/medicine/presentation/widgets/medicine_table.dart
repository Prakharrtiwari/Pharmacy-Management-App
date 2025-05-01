import 'package:flutter/material.dart';
import 'package:pharmacy_management/core/theme/app_theme.dart';
import 'package:pharmacy_management/features/medicine/domain/entities/medicine.dart';
import 'package:intl/intl.dart';

class MedicineTable extends StatefulWidget {
  final List<Medicine> medicines;
  final Function(Medicine) onEdit;
  final Function(Medicine) onDelete;

  const MedicineTable({
    super.key,
    required this.medicines,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _MedicineTableState createState() => _MedicineTableState();
}

class _MedicineTableState extends State<MedicineTable> {
  List<Medicine> filteredMedicines = [];
  TextEditingController searchController = TextEditingController();
  int _currentPage = 1;
  int _entriesPerPage = 10;
  final List<int> _entriesPerPageOptions = [10, 20, 50];

  @override
  void initState() {
    super.initState();
    _loadMedicines();
    searchController.addListener(() {
      _filterMedicines(searchController.text);
    });
  }

  @override
  void didUpdateWidget(MedicineTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.medicines != oldWidget.medicines) {
      _loadMedicines();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _loadMedicines() {
    setState(() {
      filteredMedicines = List.from(widget.medicines);
      _filterMedicines(searchController.text);
    });
  }

  void _filterMedicines(String query) {
    setState(() {
      List<Medicine> tempFiltered = List.from(widget.medicines);

      if (query.isNotEmpty) {
        tempFiltered = tempFiltered.where((medicine) {
          return medicine.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }

      filteredMedicines = tempFiltered;
      _currentPage = 1;
    });
  }

  void _resetFilters() {
    setState(() {
      searchController.clear();
      filteredMedicines = List.from(widget.medicines);
      _currentPage = 1;
    });
  }

  List<Medicine> _getPaginatedMedicines() {
    int startIndex = (_currentPage - 1) * _entriesPerPage;
    int endIndex = startIndex + _entriesPerPage;
    if (endIndex > filteredMedicines.length) {
      endIndex = filteredMedicines.length;
    }
    return filteredMedicines.sublist(startIndex, endIndex);
  }

  void _nextPage() {
    if (_currentPage < (filteredMedicines.length / _entriesPerPage).ceil()) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  Future<void> _handleEdit(Medicine medicine) async {
    TextEditingController nameController = TextEditingController(text: medicine.name);
    TextEditingController priceController = TextEditingController(text: medicine.price.toString());
    TextEditingController quantityController = TextEditingController(text: medicine.quantity.toString());
    TextEditingController expiryController = TextEditingController(text: medicine.expiryDate);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Edit Medicine',
            style: TextStyle(color: AppTheme.charcoal, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Medicine Name',
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
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    prefixIcon: Icon(Icons.attach_money, color: AppTheme.charcoal),
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
                const SizedBox(height: 12),
                TextField(
                  controller: expiryController,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date (YYYY-MM-DD)',
                    prefixIcon: Icon(Icons.calendar_today, color: AppTheme.charcoal),
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
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      expiryController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
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
                  final updatedMedicine = Medicine(
                    id: medicine.id,
                    name: nameController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    quantity: int.tryParse(quantityController.text) ?? 0,
                    expiryDate: expiryController.text,
                  );
                  widget.onEdit(updatedMedicine);
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

  Future<void> _handleDelete(Medicine medicine) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Delete Medicine',
            style: TextStyle(color: AppTheme.charcoal, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete ${medicine.name}?',
            style: const TextStyle(color: AppTheme.charcoal),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppTheme.charcoal)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.red, Color(0xFFB71C1C)],
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
                  widget.onDelete(medicine);
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
                  'Delete',
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

    final paginatedMedicines = _getPaginatedMedicines();

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
                  'Medicine Inventory',
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
                      DataColumn(label: Text('Name', style: headerStyle)),
                      DataColumn(label: Text('Price', style: headerStyle)),
                      DataColumn(label: Text('Quantity', style: headerStyle)),
                      DataColumn(label: Text('Expiry Date', style: headerStyle)),
                      DataColumn(label: Text('Actions', style: headerStyle)),
                    ],
                    rows: paginatedMedicines.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final Medicine medicine = entry.value;
                      return DataRow(
                        color: MaterialStateProperty.all(
                          index % 2 == 0
                              ? (isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF))
                              : (isDarkMode ? const Color(0xFF252525) : const Color(0xFFF9FAFB)),
                        ),
                        cells: [
                          DataCell(Text(medicine.name ?? '', style: textStyle)),
                          DataCell(Text('\$${medicine.price.toStringAsFixed(2)}', style: textStyle)),
                          DataCell(Text(medicine.quantity.toString(), style: textStyle)),
                          DataCell(Text(medicine.expiryDate ?? '', style: textStyle)),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppTheme.oliveGreen, size: 20),
                                onPressed: () => _handleEdit(medicine),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                onPressed: () => _handleDelete(medicine),
                              ),
                            ],
                          )),
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
                      'Page $_currentPage of ${(filteredMedicines.length / _entriesPerPage).ceil()}',
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
                          color: _currentPage == (filteredMedicines.length / _entriesPerPage).ceil() ? AppTheme.grey : AppTheme.charcoal,
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