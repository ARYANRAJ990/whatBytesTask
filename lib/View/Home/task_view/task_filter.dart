import 'package:flutter/material.dart';

import '../../../Resources/colors.dart';

class TaskFilterDropdown extends StatelessWidget {
  final String selectedPriorityFilter;
  final ValueChanged<String> onChanged;

  TaskFilterDropdown({required this.selectedPriorityFilter, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton<String>(
        value: selectedPriorityFilter,
        dropdownColor: Appcolors.grey,
        underline: SizedBox(),
        icon: Icon(Icons.filter_list, color: Colors.white),
        items: ["All", "Low", "Medium", "High"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) => onChanged(newValue!),
      ),
    );
  }
}
