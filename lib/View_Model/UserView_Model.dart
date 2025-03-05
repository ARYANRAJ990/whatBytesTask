import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Utils/fluttertoast.dart';
import '../Utils/Routes/routes_name.dart';
import '../View_Model/AuthView_Model.dart';
import 'package:provider/provider.dart';

class UserViewModel with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  bool isLoading = false;

  String get userId => _auth.currentUser?.uid ?? '';

  Future<bool> checkIfNumberExists(String phone, String aadhaar) async {
    try {
      QuerySnapshot phoneQuery = await _firestore.collection('users').where('phone', isEqualTo: phone).get();
      QuerySnapshot aadhaarQuery = await _firestore.collection('users').where('aadhaar', isEqualTo: aadhaar).get();

      return phoneQuery.docs.isNotEmpty || aadhaarQuery.docs.isNotEmpty;
    } catch (e) {
      print("Error checking for existing number: $e");
      return false;
    }
  }

  Future<void> saveUserDetails({
    required String name,
    required String phone,
    required String aadhaar,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      bool numberExists = await checkIfNumberExists(phone, aadhaar);
      if (numberExists) {
        Utils.flushBarErrorMessage('The phone number or Aadhaar number is already in use', context);
        isLoading = false;
        notifyListeners();
        return;
      }

      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'phone': phone,
        'aadhaar': aadhaar,
        'created_at': Timestamp.now(),
      });

      Utils.flushBarSuccessMessage('User details saved successfully', context);

      // Fetch updated name in AuthViewModel
      Provider.of<AuthViewModel>(context, listen: false).updateUserName();

      Navigator.pushNamed(context, RoutesName.task);
    } catch (e) {
      Utils.flushBarErrorMessage('Error saving data: $e', context);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
