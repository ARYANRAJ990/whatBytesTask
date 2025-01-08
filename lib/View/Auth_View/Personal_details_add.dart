import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../Utils/Routes/routes_name.dart';
import '../../Utils/fluttertoast.dart';

class UserDetailsForm extends StatefulWidget {
  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aadhaarController = TextEditingController();

  // Initialize Firebase
  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(); // Ensure Firebase is initialized
  }

  // Function to save user details to Firestore
  void _saveUserDetails() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String aadhaar = _aadhaarController.text.trim();

    // Ensure fields are not empty
    if (name.isNotEmpty && phone.isNotEmpty && aadhaar.isNotEmpty) {
      try {
        // Save to Firestore
        await FirebaseFirestore.instance.collection('users').add({
          'name': name,
          'phone': phone,
          'aadhaar': aadhaar,
          'created_at': Timestamp.now(),
        });

        // Show confirmation message
        Utils.flushBarSuccessMessage( 'User details saved successfully',context);

        // Navigate to Home Page
        Navigator.pushReplacementNamed(context,RoutesName.home);

        // Clear fields after saving
        _nameController.clear();
        _phoneController.clear();
        _aadhaarController.clear();
      } catch (e) {
        // Error handling
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error saving data: $e'),
        ));
      }
    } else {
      // Show error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFirebase(); // Ensure Firebase is initialized when the widget is created
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Personal Details')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _aadhaarController,
              decoration: InputDecoration(labelText: 'Aadhaar Card Number'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserDetails,
              child: Text('Save Details'),
            ),
          ],
        ),
      ),
    );
  }
}
