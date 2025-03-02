import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final String userId;
  final String? username; // Optional in case username is not stored
  final Timestamp timestamp;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    this.username,
    required this.timestamp,
  });

  // Convert Firestore document to NoteModel
  factory NoteModel.fromMap(Map<String, dynamic> data, String documentId) {
    return NoteModel(
      id: documentId,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      userId: data['userId'] ?? '',
      username: data['username'] ?? 'Unknown', // Default to 'Unknown' if missing
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // New method: Convert Firestore document snapshot to NoteModel
  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NoteModel.fromMap(data, doc.id);
  }
}
