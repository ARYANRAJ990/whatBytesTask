import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Utils/Routes/routes_name.dart';
import '../View_Model/AuthView_Model.dart';
import '../Resources/colors.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              final userName = authViewModel.userName ?? "Guest"; // Fetch user name
              return DrawerHeader(
                decoration: const BoxDecoration(
                    color: Appcolors.lightblue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome!!",
                      style: GoogleFonts.pacifico(
                        textStyle: const TextStyle(
                          color: Appcolors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userName, // Display user's name
                      style: GoogleFonts.pacifico(
                        textStyle: const TextStyle(
                          color: Appcolors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Account'),
            onTap: () {
              Navigator.pushNamed(context, RoutesName.userdetails);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
              authViewModel.signOutGoogle(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
