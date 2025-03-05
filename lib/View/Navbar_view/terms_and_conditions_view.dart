import 'package:flutter/material.dart';

import '../../Resources/colors.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        foregroundColor: Appcolors.white,
        backgroundColor: Appcolors.brown,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._termsList(),
            const SizedBox(height: 15),
            _buildHeader('Points Details', context),
            const SizedBox(height: 15),
            _buildTable(),
          ],
        ),
      ),
    );
  }

  // Reusable List for terms
  List<Widget> _termsList() {
    final terms = [
      'Points cannot be exchanged for cash',
      'Valid from 1st Jan 2025 to 31st Dec 2025',
      'Not valid on project rates',
      'Items are subject to availability',
      'Trip is Non-Transferrable',
    ];

    return terms.map((term) => _buildRow(term)).toList();
  }

  // Simplified reusable Row widget for terms
  Row _buildRow(String text) {
    return Row(
      children: [
        const Icon(Icons.circle, color: Appcolors.black, size: 16),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
      ],
    );
  }

  // Header for Points Details section
  Widget _buildHeader(String title, BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: Appcolors.brown,
        child: Center(
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }

  // Optimized Table method
  Table _buildTable() {
    return Table(
      border: TableBorder.all(color: Appcolors.brown),
      columnWidths: {0: FlexColumnWidth(3), 1: FlexColumnWidth(3), 2: FlexColumnWidth(2)},
      children: [
        _buildTableRow(['Material', 'Pricing', 'Points'], isHeader: true),
        ..._buildTableData(),
      ],
    );
  }

  // Simplified Table Row generation
  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration: isHeader ? BoxDecoration(color: Appcolors.brown) : null,
      children: cells.map((cell) => _buildTableCell(cell, isHeader)).toList(),
    );
  }

  // Table Data Rows
  List<TableRow> _buildTableData() {
    return [
      _buildTableRow(['18MM/19MM', '65-80', '40']),
      _buildTableRow(['Ply 12MM', '65-80', '20']),
      _buildTableRow(['Ply 9 MM', '65-80', '12']),
      _buildTableRow(['Ply 18 MM', '80-100', '50']),
      _buildTableRow(['Ply 12 MM', '80-100', '25']),
      _buildTableRow(['Ply 9 MM', '80-100', '15']),
      _buildTableRow(['OffWhite', '400-600', '12']),
      _buildTableRow(['Mica 0.8MM', '800-1000', '20']),
      _buildTableRow(['Mica 1MM', 'Upto 2000, 3000, 3000', '50, 100, 150']),
      _buildTableRow(['Veneer', 'Above 100, 150', '150, 300']),
      _buildTableRow(['Louvers', '5"- 8", 10"- 12"', '50, 80']),
      _buildTableRow(['Pare', 'per Sq.Ft', '10']),
      _buildTableRow(['Wallpapers', 'any', '100']),
      _buildTableRow(['Charcoal', '8 * 2, 8 * 4', '50, 100']),
      _buildTableRow(['Acrylic', 'Any', '150']),
      _buildTableRow(['Decoratives', '3000-5000, 5000-8000, 8000-15000, 15000-25000, Above 25000', '100, 150, 200, 300, 500']),
      _buildTableRow(['Wooden Floor', 'per Sq.Ft', '10']),
      _buildTableRow(['Starbull Aquashield', 'Per Kg', '10']),
      _buildTableRow(['Starbull HD Plus', 'Per Kg', '15']),
    ];
  }

  // Helper method to create individual table cells
  Widget _buildTableCell(String text, bool isHeader) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Appcolors.white : Appcolors.black,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}