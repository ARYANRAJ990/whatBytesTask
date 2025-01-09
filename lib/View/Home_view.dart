import 'package:flutter/material.dart';
import 'package:world_of_wood/Resources/colors.dart';

import 'Side_navbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int points = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Points'),
        backgroundColor: Appcolors.brown,
        foregroundColor: Appcolors.white,
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: const NavBar(),
        ),
      ),
      body: Center(
        child: Material(
          elevation: 20,
          shadowColor: Colors.black.withOpacity(1),
          shape: const CircleBorder(),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.brown,
                width: 4,
              ),
            ),
            padding: const EdgeInsets.all(4),
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.blue,
              child: Text(
                points.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomAppBar(
          child: Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Your action here
                print('History button pressed');
              },
              icon: const Icon(Icons.history, size: 30),
              label: const Text(
                'Points History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                backgroundColor: Appcolors.brown, // Button background color
                foregroundColor: Colors.white, // Text and icon color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
