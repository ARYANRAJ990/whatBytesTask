import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Resources/colors.dart';
import '../../Utils/Routes/routes_name.dart';
import '../../Utils/constrainst/Button_Style.dart';
import '../../Utils/constrainst/Text_Style.dart';
import '../../Utils/fluttertoast.dart';
import '../../View_Model/AuthView_Model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isEmailLoginLoading = false;
  bool _isGoogleLoginLoading = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Appcolors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Positioned "Login" Text
            Positioned(
              top: 70,
              left: 20,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Log',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Appcolors.lightblue,
                      ),
                    ),
                    TextSpan(
                      text: 'in',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Appcolors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Main Content
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),

                    // Login Image
                    Image.asset(
                      'images/task_login.png',
                      height: 220,
                      width: 320,
                    ),
                    const SizedBox(height: 50),

                    // Email Input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RoutesName.resetPassword);
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: Appcolors.lightblue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Login with Email Button
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: _isEmailLoginLoading
                            ? null
                            : () async {
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            setState(() => _isEmailLoginLoading = true);
                            await authProvider.signInWithEmail(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              context,
                            );
                            setState(() => _isEmailLoginLoading = false);
                          } else {
                            Utils.flushBarErrorMessage(
                                'Please enter email and password',
                                context);
                          }
                        },
                        style: LSFbutton_Style,
                        child: _isEmailLoginLoading
                            ? const CircularProgressIndicator(
                            color: Colors.white)
                            : Text("Login with Email", style: KTextStyle),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.shade400,
                            indent: 20,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          "OR",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.shade400,
                            indent: 10,
                            endIndent: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Google Sign-In
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: _isGoogleLoginLoading
                            ? null
                            : () async {
                          setState(() => _isGoogleLoginLoading = true);
                          await authProvider.signInWithGoogle(context);
                          setState(() => _isGoogleLoginLoading = false);
                        },
                        style: LSFbutton_Style,
                        child: _isGoogleLoginLoading
                            ? const CircularProgressIndicator(
                            color: Colors.white)
                            : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('images/google_icon.png',
                                height: 40, width: 40),
                            const SizedBox(width: 10),
                            Text('Login with Google', style: KTextStyle),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Navigate to Signup Screen
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesName.signup);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(color: Appcolors.black),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style:
                              const TextStyle(color: Appcolors.lightblue),
                            ),
                          ],
                        ),
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
