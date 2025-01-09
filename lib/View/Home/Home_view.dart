import 'package:flutter/material.dart';
import 'package:world_of_wood/Resources/colors.dart';

import '../../Utils/Routes/routes_name.dart';
import '../Side_navbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int points = 100;
  int _selectedIndex = 0; // Track the selected index

  // Function to handle bottom navigation taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      // Points History action
      print('Points History button pressed');

    } else if (_selectedIndex == 1) {
      // Points Redemption action
      print('Points Redemption button pressed');
      Navigator.pushNamed(context, RoutesName.PointsRedeem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points'),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Points History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.redeem),
            label: 'Points Redeemption',
          ),
        ],
        selectedItemColor: Appcolors.brown,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }
}
