import 'package:flutter/material.dart';

class MainBottomTabbar extends StatefulWidget {
  const MainBottomTabbar({super.key});

  @override
  State<MainBottomTabbar> createState() => _MainBottomTabbarState();
}

class _MainBottomTabbarState extends State<MainBottomTabbar> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [],
      ),
      body: IndexedStack(
        index: 0,
        children: [

      ]),
    );
  }
}