
import 'package:app_car_rental/screen/history.dart';
import 'package:app_car_rental/screen/home_page.dart';
import 'package:app_car_rental/screen/login.dart';
import 'package:app_car_rental/screen/notification_page.dart';
import 'package:app_car_rental/screen/pagepersonal.dart';
import 'package:app_car_rental/screen/suport_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../const/color.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, String? userId});

  @override
  State<MainPage> createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;
  static FirebaseAuth auth = FirebaseAuth.instance;
  final List<Widget> _pages = [
    const HomePage(),
    NotificationPage(),
    History(uid: "VASyEU2KqBc4QiyAYPRGruyMCOH2"),
    const SuportPage(),
    const Pagepersonal(),
    const Loginpage(fromPage: null, proId: null),
  ];
  bool checkLogin () {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null)
      {
        return true;
      }
    else {return  false;}
  }
  void _onItemTapped (int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 4) { // Check if Profile icon is tapped
        if (!checkLogin()) { // If not logged in
          Navigator.push( // Navigate to login page
            context,
            MaterialPageRoute(builder: (context) => Loginpage(fromPage: null, proId: null)),
          );
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem> [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.home),
      //         label: 'Home'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.notifications),
      //         label: 'Thông Báo'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.car_crash),
      //         label: 'Lịch Sử'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.contact_support),
      //         label: 'Hỗ Trợ'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.supervised_user_circle_rounded),
      //         label: 'Profile'),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Color(dart_green),
      //   unselectedItemColor: Colors.grey,
      //   onTap: _onItemTapped,
      // ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: GNav(
            gap: 8,
            hoverColor: Colors.grey[100]!,
            backgroundColor: Colors.white.withOpacity(0.8),
            activeColor: Colors.white,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Color(dart_green),
            color: Color(dart_green),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.notifications,
                text: 'Thông báo',
              ),
              GButton(
                icon: Icons.car_crash,
                text: 'Lịch sử',
              ),
              GButton(
                icon: Icons.contact_support,
                text: 'Hỗ trợ',
              ),
              GButton(
                icon: Icons.supervised_user_circle_rounded,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
