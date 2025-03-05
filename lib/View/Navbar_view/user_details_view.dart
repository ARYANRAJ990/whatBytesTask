import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Resources/colors.dart';
import '../../Utils/Routes/routes_name.dart';
import '../../Utils/constrainst/Button_Style.dart';
import '../../Utils/constrainst/Text_Style.dart';
import '../../View_Model/AuthView_Model.dart';

class UserDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Appcolors.white,
      appBar: AppBar(
        title: Text('Your Details', style: AppbarText),
        backgroundColor: Appcolors.lightblue,
        foregroundColor: Appcolors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(authProvider.currentUser?.uid) // Get user ID from Auth
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No user details available.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String name = userData['name'] ?? 'N/A';
          String phone = userData['phone'] ?? 'N/A';
          String aadhaar = userData['aadhaar'] ?? 'N/A';

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                  crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                  children: [
                    Icon(Icons.person, size: 200, color: Appcolors.lightblue),
                    Text(
                      'Name: $name',
                      style: KTextStyle2.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Phone Number: $phone',
                      style: KTextStyle2.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Aadhaar: $aadhaar',
                      style: KTextStyle2.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Add any functionality if you want to edit or update user details
                        Navigator.pushNamed(context, RoutesName.userProfile); // Example
                      },
                      style: LSFbutton_Style,
                      child: Text('Edit Details', style: KTextStyle),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
