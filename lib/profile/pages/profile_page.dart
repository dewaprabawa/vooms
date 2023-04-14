import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vooms/app.dart';
import 'package:vooms/authentications/pages/blocs/app_state_cubit/app_state_cubit.dart';
import 'package:vooms/authentications/pages/sign_in_page/sign_in_page.dart';
import 'package:vooms/bottom_nav_bar/main_bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStateCubit, AppStateState>(
      listener: (context, state) {
        if(state.appStateStatus == AppStateStatus.notAuthenticated){
          //  var route =
          //     CupertinoPageRoute(builder: ((context) => const OnStartUpPage()));
          // Navigator.pushAndRemoveUntil(context, route, (route) => false);
          return;
        }
      },
      child: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () async {
              await context.read<AppStateCubit>().signOut();
            },
            child: Text("Log out"),
          ),
        ),
      ),
    );
  }
}
