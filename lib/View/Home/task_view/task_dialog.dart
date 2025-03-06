import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../View_Model/taskViewModel.dart';

void showAddTaskDialog(BuildContext context) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedPriority = "Medium";

  final _formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Add Task"),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: "Title"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Title cannot be empty";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: "Description"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Description cannot be empty";
                        }
                        return null;
                      },
                    ),
                    ListTile(
                      title: Text("Due Date: ${selectedDate.toLocal().toString().split(' ')[0]}"),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: InputDecoration(labelText: "Priority"),
                      items: ["Low", "Medium", "High"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedPriority = newValue!;
                        });
                      },
                      validator: (value) => value == null ? "Please select a priority" : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<TasksViewModel>(context, listen: false).addTask(
                      titleController.text.trim(),
                      descriptionController.text.trim(),
                      selectedDate,
                      selectedPriority,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text("Add"),
              ),
            ],
          );
        },
      );
    },
  );
}