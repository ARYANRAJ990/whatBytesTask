import 'package:flutter/material.dart';
import '../Model/note_model.dart';
import '../Services/Firebase_services/notes_service.dart';

class NotesViewModel extends ChangeNotifier {
  final NotesService _notesService = NotesService();
  bool isLoading = false;

  // Add Note
  Future<void> addNote(String title, String content, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _notesService.addNote(title, content);
    } catch (e) {
      print("Error adding note: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Notes
  Stream<List<NoteModel>> getNotes() {
    return _notesService.getNotes();
  }

  // Delete Note
  Future<void> deleteNote(String noteId) async {
    await _notesService.deleteNote(noteId);
    notifyListeners();
  }
}
