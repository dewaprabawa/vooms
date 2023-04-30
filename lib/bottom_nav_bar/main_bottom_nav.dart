import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vooms/activity/pages/tutor_list_page.dart';
import 'package:vooms/activity/pages/tutor_cubit/tutor_cubit.dart';
import 'package:vooms/authentication/repository/user_repository.dart';
import 'package:vooms/chat/pages/chat_conversation_page.dart';
import 'package:vooms/dependency.dart';
import 'package:vooms/profile/pages/cubit/profile_cubit.dart';
import 'package:vooms/profile/pages/profile_page.dart';
import 'package:vooms/shareds/general_helper/ui_asset_constant.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key});

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  int selectedPageIndex = 0;

  final List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(UIAssetConstants.classRoom)), label: "Activity"),
         BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(UIAssetConstants.classChat)), label: "Chat"),
    BottomNavigationBarItem(icon: ImageIcon(AssetImage(UIAssetConstants.classProgress)), label: "Profile"),
  ];

  final pages = const [TutorListPage(), ChatConversationPage() ,ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ProfileCubit>()),
        BlocProvider(create: (context) => sl<TutorCubit>()),
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
