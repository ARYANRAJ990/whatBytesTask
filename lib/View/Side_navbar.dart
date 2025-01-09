import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Utils/Routes/routes_name.dart';
import '../View_Model/AuthView_Model.dart';
import 'package:world_of_wood/Resources/colors.dart';

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
              final userName = authViewModel.currentUser?.displayName ?? "Guest";
              return DrawerHeader(
                decoration: const BoxDecoration(
                  color: Appcolors.brown,
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
                      userName,
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
              // Handle navigation to My Account
              Navigator.pushNamed(context, RoutesName.userdetails);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle navigation to Settings
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.priority_high),
            title: const Text('Terms and Conditions'),
            onTap: () {
              // Handle navigation to History
              Navigator.pushNamed(context, RoutesName.terms);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout
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
