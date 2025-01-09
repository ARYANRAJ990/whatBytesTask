import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Services/Firebase_services/google_firebase_service.dart';
import '../Utils/Routes/routes_name.dart';
import '../Utils/fluttertoast.dart';

class AuthViewModel with ChangeNotifier {
  final FirebaseGoogleService _firebaseGoogleService = FirebaseGoogleService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  User? _currentUser;

  User? get currentUser => _auth.currentUser;
  String? get userEmail => currentUser?.email;

  // Check if user exists
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
      // Google Sign-In Process
      User? user = await FirebaseGoogleService().signInWithGoogle();

      if (user != null) {
        // Check if the user email exists in Firestore
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (doc.exists) {
          // If user details exist, navigate to Home Page
          Navigator.pushReplacementNamed(context, RoutesName.home);
        } else {
          // If no user details, navigate to Add User Details Page
          Navigator.pushNamed(context, RoutesName.userProfile);
        }
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
      Utils.flushBarErrorMessage('Error: $e', context);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Check if the user has entered their details
  Future<bool> _checkIfUserDetailsExist() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          // Check if all the necessary fields are present
          final data = doc.data();
          return data?['name'] != null && data?['phone'] != null && data?['aadhaar'] != null;
        }
      }
      return false;
    } catch (e) {
      print("Error checking user details: $e");
      return false;
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
