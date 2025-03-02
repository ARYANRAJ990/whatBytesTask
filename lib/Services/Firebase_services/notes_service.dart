import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Model/note_model.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add Note
  Future<void> addNote(String title, String content) async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection('notes').add({
      'userId': userId,
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Fetch Notes
  Stream<List<NoteModel>> getNotes() {
    return _firestore
        .collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => NoteModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Delete Note
  Future<void> deleteNote(String noteId) async {
    await _firestore.collection('notes').doc(noteId).delete();
  }
}
