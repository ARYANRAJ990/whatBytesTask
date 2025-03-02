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

  // Check if user exists in Firestore
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
      User? user = await _firebaseGoogleService.signInWithGoogle();

      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (doc.exists) {
          Navigator.pushReplacementNamed(context, RoutesName.notes);
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

  // Email & Password Sign-Up
  Future<void> signUpWithEmail(String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'createdAt': DateTime.now().toIso8601String(),
        });

        Navigator.pushReplacementNamed(context, RoutesName.notes);
      }
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();

      print("Firebase Auth Error: ${e.code}");

      if (e.code == 'email-already-in-use') {
        Utils.flushBarErrorMessage('This email is already registered. Please log in.', context);
      } else if (e.code == 'weak-password') {
        Utils.flushBarErrorMessage('The password is too weak. Please use a stronger password.', context);
      } else if (e.code == 'invalid-email') {
        Utils.flushBarErrorMessage('Invalid email format. Please enter a valid email.', context);
      } else {
        Utils.flushBarErrorMessage('Error: ${e.message}', context);
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Email & Password Login
  Future<void> signInWithEmail(String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, RoutesName.notes);

    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();

      print("Firebase Auth Error: ${e.code}");

      if (e.code == 'wrong-password') {
        Utils.flushBarErrorMessage('Incorrect password. Please try again.', context);
      } else if (e.code == 'user-not-found') {
        Utils.flushBarErrorMessage('No account found with this email.', context);
      } else if (e.code == 'invalid-credential') {
        Utils.flushBarErrorMessage('Invalid email or password. Please check and try again.', context);
      } else {
        Utils.flushBarErrorMessage('Error: ${e.message}', context);
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Reset Password
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      // Validate email format
      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
        Utils.flushBarErrorMessage("Enter a valid email address.", context);
        return;
      }

      // Check if email exists in Firestore
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Utils.flushBarErrorMessage("This email is not registered.", context);
        return;
      }

      // Send reset email if user exists
      await _auth.sendPasswordResetEmail(email: email);
      Utils.flushBarErrorMessage('Password reset link sent to $email', context);

    } catch (e) {
      Utils.flushBarErrorMessage("An unexpected error occurred.", context);
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

  // Email & Password Logout
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
