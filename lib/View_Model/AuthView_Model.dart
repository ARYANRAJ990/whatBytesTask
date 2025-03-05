import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Services/Firebase_services/google_firebase_service.dart';
import '../Utils/Routes/routes_name.dart';
import '../Utils/fluttertoast.dart';

class AuthViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseGoogleService _firebaseGoogleService = FirebaseGoogleService();

  bool isLoading = false;
  User? _currentUser;
  String? _userName;

  User? get currentUser => _auth.currentUser;
  String? get userEmail => currentUser?.email;
  String? get userName => _userName;

  AuthViewModel() {
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          _userName = doc.data()?['name'] ?? "Guest";
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error fetching user name: $e");
    }
  }

  Future<void> updateUserName() async {
    await _fetchUserName();
  }

  Future<bool> checkUserExists() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        return doc.exists;
      }
      return false;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      User? user = await _firebaseGoogleService.signInWithGoogle();

      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          Navigator.pushReplacementNamed(context, RoutesName.task);
        } else {
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

  Future<void> signUpWithEmail(String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'createdAt': DateTime.now().toIso8601String(),
        });
        Navigator.pushReplacementNamed(context, RoutesName.task);
      }
    } catch (e) {
      print("Error: $e");
      Utils.flushBarErrorMessage('Error: $e', context);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithEmail(String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, RoutesName.task);
    } catch (e) {
      print("Error: $e");
      Utils.flushBarErrorMessage('Error: $e', context);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Utils.flushBarErrorMessage('Password reset link sent to $email', context);
    } catch (e) {
      print("Error: $e");
      Utils.flushBarErrorMessage('Error: $e', context);
    }
  }

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

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
      Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
    } catch (e) {
      print("Error during Sign-Out: $e");
    }
  }
}