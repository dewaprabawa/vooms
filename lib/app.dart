import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vooms/authentications/pages/blocs/signin_cubit/sign_in_cubit.dart';
import 'package:vooms/authentications/pages/blocs/signup_cubit/sign_up_cubit.dart';
import 'package:vooms/authentications/repository/auth_repository.dart';
import 'package:vooms/authentications/repository/auth_services.dart';
import 'package:vooms/authentications/repository/user_service_remote_impl.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentications/pages/sign_up_page/sign_up_page.dart';


class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final authRepository = AuthRepositoryImpl(
      AuthServicesImpl(FirebaseAuth.instance, GoogleSignIn()),
      UserServiceRemoteImpl(FirebaseFirestore.instance, ));

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpCubit(authRepository)),
        BlocProvider(create: (context) => SignInCubit(authRepository))
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
