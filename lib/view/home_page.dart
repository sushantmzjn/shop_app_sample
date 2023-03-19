import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shop_app/view/pages/home.dart';
import 'package:shop_app/view/pages/profile.dart';

import '../provider/auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {



  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Center(child: Text('cart',style: optionStyle,)),
    Center(child: Text('hjk',style: optionStyle,)),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),

        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))
        ),
        child: GNav(
          backgroundColor: Colors.black,
          tabBackgroundColor: Colors.deepPurple.shade800,
          tabActiveBorder: Border.all(color: Colors.white),
          textSize: 0.0,
          color: Colors.white,
          activeColor: Colors.white,
          gap: 8,
          padding: EdgeInsets.all(16.0),
          selectedIndex: _selectedIndex,
          onTabChange: (index){
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: [
            GButton(icon: CupertinoIcons.home, text: 'Home',),
            GButton(icon: CupertinoIcons.list_bullet, text: 'Order',),
            GButton(icon: CupertinoIcons.cart, text: 'Cart',),
            GButton(icon: CupertinoIcons.person, text: 'Profile',),
          ],
        ),
      ),
    );
  }
}
