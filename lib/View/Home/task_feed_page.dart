import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Services/task_model.dart';
import '../../View_Model/taskViewModel.dart';
import '../Side_navbar.dart';
import 'package:intl/intl.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String selectedPriorityFilter = "All";
  bool showCompleted = true;

  @override
  Widget build(BuildContext context) {
    final tasksViewModel = Provider.of<TasksViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
        actions: [
          DropdownButton<String>(
            value: selectedPriorityFilter,
            items: ["All", "Low", "Medium", "High"].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedPriorityFilter = newValue!;
              });
            },
          ),
          Switch(
            value: showCompleted,
            onChanged: (value) {
              setState(() {
                showCompleted = value;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddTaskDialog(context, tasksViewModel),
          )
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: const NavBar(),
        ),
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: tasksViewModel.getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var tasks = snapshot.data!;
          tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

          tasks = tasks.where((task) {
            if (selectedPriorityFilter != "All" && task.priority != selectedPriorityFilter) {
              return false;
            }
            if (!showCompleted && task.isCompleted) {
              return false;
            }
            return true;
          }).toList();

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text("${task.description}\nDue: ${DateFormat.yMMMd().format(task.dueDate)}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        tasksViewModel.updateTaskStatus(task.id, value!);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => tasksViewModel.deleteTask(task.id),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TasksViewModel tasksViewModel) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedPriority = "Medium";

    void _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
              DropdownButton<String>(
                value: selectedPriority,
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Due Date: ${DateFormat.yMMMd().format(selectedDate)}"),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text("Select Date"),
                  )
                ],
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                tasksViewModel.addTask(
                  titleController.text.trim(),
                  descriptionController.text.trim(),
                  selectedDate,
                  selectedPriority,
                );
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
