import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vooms/authentications/repository/auth_repository.dart';
import 'package:vooms/authentications/repository/auth_services.dart';
import 'package:vooms/authentications/repository/user_services.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentications/pages/sign_up/sign_up_page.dart';
import 'authentications/pages/sign_up/signup_cubit/sign_up_cubit.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final authRepository = AuthRepositoryImpl(
      AuthServicesImpl(FirebaseAuth.instance, GoogleSignIn()),
      UserStoreImpl(FirebaseFirestore.instance));

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpCubit(authRepository))
      ],
      child: MaterialApp(
        title: 'Vooms',
        theme: ThemeData(
            primarySwatch: UIColorConstant.materialPrimaryBlue,
            hintColor: UIColorConstant.accentGrey1,
            errorColor: UIColorConstant.primaryRed,
            fontFamily: GoogleFonts.dmMono().toString()),
        home: const SignUpPage(),
      ),
    );
  }
}
