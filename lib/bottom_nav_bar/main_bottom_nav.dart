import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vooms/activity/pages/activity_page.dart';
import 'package:vooms/authentications/repository/user_repository.dart';
import 'package:vooms/profile/pages/cubit/profile_cubit.dart';
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
        icon: Icon(Icons.local_activity), label: "Aktivitas"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];

  final pages = const [ActivityPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = context.read<UserRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileCubit(userRepository)),
      ],
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedPageIndex,
            onTap: (index) {
              setState(() {
                selectedPageIndex = index;
              });
            },
            items: items),
        body: IndexedStack(index: selectedPageIndex, children: pages),
      ),
    );
  }
}
