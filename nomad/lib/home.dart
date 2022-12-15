// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:nomad/NavBar/addList.dart';
import 'package:nomad/utils.dart';
import 'NavBar/HomeTabPage.dart';
import 'NavBar/OptionTabPage.dart';
import 'NavBar/SearchTabPage.dart';
import 'NavBar/ShareTabPage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  final tabs = [
    HomeTabPage(),
    ShareTabPage(),
    SearchTabPage(),
    OptionTabpage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddList()));
        },
        backgroundColor: dark,
        elevation: 10,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 26,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: [Icons.home_outlined, Icons.search, Icons.share, Icons.menu],
          activeIndex: selectedIndex,
          gapLocation: GapLocation.end,
          activeColor: dark,
          inactiveColor: light,
          notchSmoothness: NotchSmoothness.defaultEdge,
          backgroundColor: background,
          iconSize: 26,
          elevation: 50,
          onTap: (index) => setState(() => selectedIndex = index)),
      body: tabs[selectedIndex],
    );
  }
}