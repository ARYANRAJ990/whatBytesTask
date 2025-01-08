import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Services/Firebase_services/google_firebase_service.dart';
import '../Utils/Routes/routes_name.dart';

class AuthViewModel with ChangeNotifier {
  final FirebaseGoogleService _firebaseGoogleService = FirebaseGoogleService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  User? _currentUser;

  User? get currentUser => _auth.currentUser;
  String? get userEmail => currentUser?.email;

//check user exists
  Future<bool> checkUserExists() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        return doc.exists;
      }
      return false;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }
  // Google Sign-In
  Future<void> signInWithGoogle(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _firebaseGoogleService.signInWithGoogle();
      if (_currentUser != null) {
        notifyListeners();
        Navigator.pushReplacementNamed(context, RoutesName.home);
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Google Sign-Out
  Future<void> signOutGoogle(BuildContext context) async {
    try {
      await _firebaseGoogleService.signOutGoogle();
      _currentUser = null;
      notifyListeners();
      Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
    } catch (e) {
      print("Error during Google Sign-Out: $e");
    }
  }
}
