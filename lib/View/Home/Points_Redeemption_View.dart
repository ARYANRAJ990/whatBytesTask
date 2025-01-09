import 'package:flutter/material.dart';
import 'package:world_of_wood/Resources/colors.dart';

class PointsRedeemptionView extends StatelessWidget {
  const PointsRedeemptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points Redemption'),
        foregroundColor: Appcolors.white,
        backgroundColor: Appcolors.brown,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Appliances Redemption', context),
            const SizedBox(height: 15),
            _buildTable1(),

            const SizedBox(height: 30), // Space between tables

            _buildHeader('Travel Redemption✈️', context),
            const SizedBox(height: 15),
            _buildTable2(),
          ],
        ),
      ),
    );
  }

  // Header for Redemption Section
  Widget _buildHeader(String title, BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: Appcolors.brown,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
  // First Table (Electronics)
  Table _buildTable1() {
    return Table(
      border: TableBorder.all(color: Appcolors.brown),
      columnWidths: {0: FlexColumnWidth(3), 1: FlexColumnWidth(2)},
      children: [
        _buildTableRow(['Appliances', 'Points Redemption'], isHeader: true),
        _buildTableRow(['Microwave', '10,000']),
        _buildTableRow(['Washing Machine/Fridge', '17,000']),
        _buildTableRow(['Mobile Phone/TV/Split AC', '35,000']),
      ],
    );
  }

  // Second Table (Home Appliances)
  Table _buildTable2() {
    return Table(
      border: TableBorder.all(color: Appcolors.brown),
      columnWidths: {0: FlexColumnWidth(3), 1: FlexColumnWidth(2)},
      children: [
        _buildTableRow(['Destination', 'Points Per Ticket'], isHeader: true),
        _buildTableRow(['Thailand', '60,000']),
        _buildTableRow(['Nanital/Shimla/Mussourie', '2 Tickets - 45,000, 1 Ticket - 25,000']),

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
