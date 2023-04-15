import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/authentication/pages/blocs/app_state_cubit/app_state_cubit.dart';
import 'package:vooms/authentication/repository/user_entity.dart';
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
    return MultiBlocListener(
      listeners: [
        BlocListener<AppStateCubit, AppStateState>(
          listener: (context, state) {
            if(state.appStateStatus == AppStateStatus.failure){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Terjadi kesalahan", style: GoogleFonts.dmMono(),),
              action: SnackBarAction(
                label: 'Coba Lagi',
                onPressed: () {},
              ),
            ));
            }
          },
        ),
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {

          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                switch (state.profileStatus) {
                  case ProfileStatus.initial:
                  case ProfileStatus.loaded:
                    return _BuildDetailHeader(
                      entity: state.entity!,
                    );
                  case ProfileStatus.failure:
                    return _ErrorTextMessage(text: state.mesaage);
                  case ProfileStatus.loading:
                    return const _LoadingShimmer();
                }
              }),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tentang saya',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                    await context.read<AppStateCubit>().signOut();
                  },
                  child: Text("SignOut",style: GoogleFonts.dmMono()))
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorTextMessage extends StatelessWidget {
  const _ErrorTextMessage({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _BuildDetailHeader extends StatelessWidget {
  const _BuildDetailHeader({super.key, required this.entity});
  final UserEntity entity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(entity.photoUrl),
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
            const SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(entity.photoUrl),
            ),
            const SizedBox(height: 10),
            Text(
              entity.fullname,
              style: GoogleFonts.dmMono(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              entity.email,
              style: GoogleFonts.dmMono(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              entity.phone,
              style: GoogleFonts.dmMono(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
