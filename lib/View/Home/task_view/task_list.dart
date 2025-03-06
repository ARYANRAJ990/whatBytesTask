import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../Services/task_model.dart';
import '../../../View_Model/taskViewModel.dart';

class TaskList extends StatelessWidget {
  final String selectedPriorityFilter;
  final bool showCompleted;
  final bool showPending;
  final bool showDueSoon;
  final TextEditingController searchController;

  TaskList({
    required this.selectedPriorityFilter,
    required this.showCompleted,
    required this.showPending,
    required this.showDueSoon,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final tasksViewModel = Provider.of<TasksViewModel>(context);

    return StreamBuilder<List<TaskModel>>(
      stream: tasksViewModel.getTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var tasks = snapshot.data!;
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

        tasks = tasks.where((task) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final dueDate = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
          final difference = dueDate.difference(today).inDays;
          final isOverdue = difference < 0;

          // Debugging to check filtering
          print("Checking Task: ${task.title}, Due: ${task.dueDate}, Difference: $difference");

          if (selectedPriorityFilter != "All" && task.priority != selectedPriorityFilter) {
            return false;
          }
          if (!showCompleted && task.isCompleted) {
            return false;
          }
          if (showPending && !isOverdue) {
            return false;
          }
          if (showDueSoon && (difference != 1 && difference != 0)) {
            return false;
          }
          if (searchController.text.isNotEmpty &&
              !task.title.toLowerCase().contains(searchController.text.toLowerCase())) {
            return false;
          }
          return true;
        }).toList();

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final dueDate = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
            final difference = dueDate.difference(today).inDays;
            final isOverdue = difference < 0;

            return ListTile(
              title: Text(task.title,
                  style: TextStyle(
                    color: isOverdue ? Colors.orange : (difference == 0 ? Colors.red : Colors.black),
                    fontWeight: isOverdue || difference == 0 ? FontWeight.bold : FontWeight.normal,
                  )),
              subtitle: Text(
                "${task.description}\nDue: ${DateFormat.yMMMd().format(task.dueDate)}"
                    "${isOverdue ? " - ⚠️ Overdue!" : (difference == 0 ? " - ⚠️ Due Today!" : (difference == 1 ? " - ⚠️ Due Soon!" : ""))}",
                style: TextStyle(
                  color: isOverdue ? Colors.orange : (difference == 0 ? Colors.red : Colors.black),
                ),
              ),
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
                    onPressed: () {
                      tasksViewModel.deleteTask(task.id);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
