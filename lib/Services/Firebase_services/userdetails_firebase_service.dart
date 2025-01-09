import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if phone or Aadhaar exists
  Future<bool> checkIfNumberExists(String phone, String aadhaar) async {
    try {
      final phoneQuery = await _firestore.collection('users').where('phone', isEqualTo: phone).get();
      final aadhaarQuery = await _firestore.collection('users').where('aadhaar', isEqualTo: aadhaar).get();
      return phoneQuery.docs.isNotEmpty || aadhaarQuery.docs.isNotEmpty;
    } catch (e) {
      print("Error checking existing numbers: $e");
      return false;
    }
  }

  // Save User Details
  Future<void> saveUserDetails(String userId, Map<String, dynamic> userDetails) async {
    await _firestore.collection('users').doc(userId).set(userDetails);
  }
}
