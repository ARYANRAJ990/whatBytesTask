import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_of_wood/Resources/colors.dart';
import 'dart:async';

import '../Utils/Routes/routes_name.dart';
import '../View_Model/AuthView_Model.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String _appName = "World of Wood";
  List<bool> _visibleLetters = [];

  @override
  void initState() {
    super.initState();
    _visibleLetters = List<bool>.filled(_appName.length, false);
    _animateText();
    _checkAuthenticationStatus();
  }

  // Animate each letter appearing one by one
  void _animateText() async {
    for (int i = 0; i < _appName.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        _visibleLetters[i] = true;
      });
    }
  }

  // Check user authentication status using AuthViewModel
  void _checkAuthenticationStatus() async {
    await Future.delayed(const Duration(seconds: 4)); // Wait for splash animation

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (authViewModel.currentUser != null) {
      // If user is signed in, navigate to Home
      Navigator.pushReplacementNamed(context, RoutesName.notes);
    } else {
      // If user is not signed in, navigate to Login
      Navigator.pushReplacementNamed(context, RoutesName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'images/wood_logo_bg.png',
              height: 150,
            ),
            const SizedBox(height: 20),

            // App Name Letter-by-Letter Animation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _appName.split('').asMap().entries.map((entry) {
                int index = entry.key;
                String letter = entry.value;
                return AnimatedOpacity(
                  opacity: _visibleLetters[index] ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    letter,
                    style: GoogleFonts.knewave(
                      textStyle: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Appcolors.brown,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Loading Indicator
            CircularProgressIndicator(
              color: Appcolors.brown,
            ),
          ],
        ),
      ),
    );
  }
}
