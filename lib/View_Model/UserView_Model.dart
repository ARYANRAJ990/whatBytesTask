import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Utils/fluttertoast.dart';
import '../Utils/Routes/routes_name.dart';

class UserViewModel with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  bool isLoading = false;

  // Get current user's ID
  String get userId => _auth.currentUser?.uid ?? '';

  // Function to check if the phone number or Aadhaar number already exists
  Future<bool> checkIfNumberExists(String phone, String aadhaar) async {
    try {
      QuerySnapshot phoneQuery = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      QuerySnapshot aadhaarQuery = await _firestore
          .collection('users')
          .where('aadhaar', isEqualTo: aadhaar)
          .get();

      return phoneQuery.docs.isNotEmpty || aadhaarQuery.docs.isNotEmpty;
    } catch (e) {
      print("Error checking for existing number: $e");
      return false;
    }
  }

  // Function to save user details to Firestore
  Future<void> saveUserDetails({
    required String name,
    required String phone,
    required String aadhaar,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      // Check if phone or Aadhaar already exists
      bool numberExists = await checkIfNumberExists(phone, aadhaar);

      if (numberExists) {
        Utils.flushBarErrorMessage(
            'The phone number or Aadhaar number is already in use', context);
        isLoading = false;
        notifyListeners();
        return;
      }

      // Save to Firestore with user ID
      await _firestore.collection('users').doc(userId).set({
        'name': name,
       // 'phone': phone,
      //  'aadhaar': aadhaar,
        'created_at': Timestamp.now(),
      });

      // Show confirmation message
      Utils.flushBarSuccessMessage('User details saved successfully', context);

      // Navigate to Home Page
      Navigator.pushNamed(context, RoutesName.notes);
    } catch (e) {
      Utils.flushBarErrorMessage('Error saving data: $e', context);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
