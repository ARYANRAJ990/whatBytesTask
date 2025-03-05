import 'package:flutter/material.dart';
import '../Services/Firebase_services/task_services.dart';
import '../Services/task_model.dart';

class TasksViewModel extends ChangeNotifier {
  final TasksService _tasksService = TasksService();
  bool isLoading = false;

  // Add Task
  Future<void> addTask(String title, String description, DateTime dueDate, String priority) async {
    try {
      isLoading = true;
      notifyListeners();
      await _tasksService.addTask(title, description, dueDate, priority);
    } catch (e) {
      print("Error adding task: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Tasks
  Stream<List<TaskModel>> getTasks() {
    return _tasksService.getTasks();
  }

  // Update Task (Mark as complete/incomplete)
  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    await _tasksService.updateTaskStatus(taskId, isCompleted);
    notifyListeners();
  }

  // Delete Task
  Future<void> deleteTask(String taskId) async {
    await _tasksService.deleteTask(taskId);
    notifyListeners();
  }
}
