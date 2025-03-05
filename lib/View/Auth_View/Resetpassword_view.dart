import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Resources/colors.dart';
import '../../Utils/constrainst/Button_Style.dart';
import '../../Utils/constrainst/Text_Style.dart';
import '../../Utils/fluttertoast.dart';
import '../../View_Model/AuthView_Model.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Appcolors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Positioned "Reset" and "Password" separately
            Positioned(
              top: 70,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Appcolors.lightblue,
                    ),
                  ),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Appcolors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),

                    // Reset Password Image
                    Image.asset(
                      'images/reset.png', // Change this to your reset password image
                      height: 220,
                      width: 320,
                    ),
                    const SizedBox(height: 40),

                    // Email Input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Enter your email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Send Reset Link Button
                    authProvider.isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_emailController.text.isNotEmpty) {
                            authProvider.resetPassword(
                              _emailController.text.trim(),
                              context,
                            );
                          } else {
                            Utils.flushBarErrorMessage(
                                'Please enter your email', context);
                          }
                        },
                        style: LSFbutton_Style,
                        child: Text("Send Reset Link", style: KTextStyle),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Back to Login
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Back to Login",
                        style: TextStyle(color: Appcolors.lightblue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
