import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../task_model.dart';

class TasksService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add Task
  Future<void> addTask(String title, String description, DateTime dueDate, String priority) async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection('tasks').add({
      'userId': userId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'isCompleted': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Fetch Tasks
  Stream<List<TaskModel>> getTasks() {
    return _firestore
        .collection('tasks')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Update Task Status (Mark as complete/incomplete)
  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'isCompleted': isCompleted,
    });
  }

  // Delete Task
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}
