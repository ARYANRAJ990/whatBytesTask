import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:world_of_wood/View_Model/AuthView_Model.dart';
import '../../Resources/colors.dart';
import '../../Utils/Routes/routes_name.dart';
import '../../Utils/constrainst/Button_Style.dart';
import '../../Utils/constrainst/Text_Style.dart';
import '../../Utils/fluttertoast.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Appcolors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Positioned "Login" Text
            Positioned(
              top: 75,
              left: 20,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Log',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Appcolors.lightbrown,
                      ),
                    ),
                    TextSpan(
                      text: 'in',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Appcolors.brown,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Main Content
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 110.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),
                    // Normal Image in the Center
                    Image.asset(
                      'images/loginb.png',
                      height: 220,
                      width: 320,
                    ),
                    const SizedBox(height: 10),
                    // App Name Text
                    Text(
                      'World of Wood 🔨',
                      style: GoogleFonts.atma(
                        textStyle: TextStyle(
                          color: Appcolors.brown,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 100), // Space between text and button
                    // Google Sign-In Button
                    authProvider.isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!authProvider.isLoading) {
                            await authProvider.signInWithGoogle(context);
                            // Based on the checkUserDetailsExist method,
                            // the user will be routed to the appropriate page.
                          }
                        },
                        style: LSFbutton_Style,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'images/google_icon.png',
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Login with Google',
                              style: KTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
