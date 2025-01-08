import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_of_wood/View_Model/AuthView_Model.dart';
import '../../Utils/Routes/routes_name.dart';
import '../../Utils/fluttertoast.dart';

class LoginScreen extends StatelessWidget {
  final ImageProvider _backgroundImage = AssetImage('images/travel.jpg');

  @override
  Widget build(BuildContext context) {
    precacheImage(_backgroundImage, context);

    final authProvider = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image(image: _backgroundImage, fit: BoxFit.cover),
          ),
          // Blur Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          // Foreground Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'images/wood_logo_bg.png',
                    height: 200,
                    width: 300,
                  ),
                  // Adjusted spacing
                  const SizedBox(height: 20),

                  // App Name Text
                  Text(
                    'World of Wood',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30), // Space between text and button

                  // Google Sign-In Button
                  authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await authProvider.signInWithGoogle(context);
                            Navigator.pushNamed(context, RoutesName.userProfile);
                            Utils.flushBarSuccessMessage('Login Successful', context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        },
                        icon: Image.asset(
                          'images/google_icon.png',
                          height: 24,
                          width: 24,
                        ),
                        label: const Text('Sign in with Google'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
