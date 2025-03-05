import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../Services/task_model.dart';
import '../../../View_Model/taskViewModel.dart';


class TaskList extends StatelessWidget {
  final String selectedPriorityFilter;
  final bool showCompleted;
  final TextEditingController searchController;

  TaskList({
    required this.selectedPriorityFilter,
    required this.showCompleted,
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
          if (selectedPriorityFilter != "All" && task.priority != selectedPriorityFilter) {
            return false;
          }
          if (!showCompleted && task.isCompleted) {
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
            return ListTile(
              title: Text(task.title),
              subtitle: Text("${task.description}\nDue: ${DateFormat.yMMMd().format(task.dueDate)}"),
              trailing: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  tasksViewModel.updateTaskStatus(task.id, value!);
                },
              ),
              onLongPress: () => tasksViewModel.deleteTask(task.id),
            );
          },
        );
      },
    );
  }
}
