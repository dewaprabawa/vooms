import 'package:flutter/material.dart';
import 'package:vooms/activity/pages/activity_page.dart';
import 'package:vooms/profile/pages/profile_page.dart';

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key});

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  int selectedPageIndex = 0;

  final List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
        icon: Icon(Icons.local_activity), label: "aktivitas"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];

  final pages = const [ActivityPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedPageIndex,
          onTap: (index) {
            setState(() {
              selectedPageIndex = index;
            });
          },
          items: items),
      body: IndexedStack(index: selectedPageIndex, children: pages),
    );
  }
}
