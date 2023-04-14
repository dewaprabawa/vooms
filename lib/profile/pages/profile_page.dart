import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/app.dart';
import 'package:vooms/authentications/pages/blocs/app_state_cubit/app_state_cubit.dart';
import 'package:vooms/authentications/pages/sign_in_page/sign_in_page.dart';
import 'package:vooms/bottom_nav_bar/main_bottom_nav.dart';
import 'package:vooms/profile/pages/cubit/profile_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    Future.microtask(() => context.read<ProfileCubit>().getProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userEntity = context.read<ProfileCubit>().state.entity;
    return MultiBlocListener(
      listeners: [
        BlocListener<AppStateCubit, AppStateState>(
          listener: (context, state) {
            // TODO: implement listener
          },
        ),
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            // TODO: implement listener
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://www.mockofun.com/wp-content/uploads/2019/12/circle-photo.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10,),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            "https://www.mockofun.com/wp-content/uploads/2019/12/circle-photo.jpg"),
                      ),
                      SizedBox(height: 10),
                      Text(
                        userEntity!.fullname,
                        style: GoogleFonts.dmMono(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        userEntity.email,
                        style: GoogleFonts.dmMono(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        userEntity.phone,
                        style: GoogleFonts.dmMono(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About me',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo.',
                        style: GoogleFonts.dmMono(
                          fontSize: 16,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    context.read<AppStateCubit>().signOut();
                  },
                  child: Text("SignOut"))
            ],
          ),
        ),
      ),
    );
  }
}
