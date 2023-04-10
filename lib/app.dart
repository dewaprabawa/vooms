import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/on_boarding/on_boarding_page.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentications/pages/sign_up/sign_up_page.dart';
import 'authentications/pages/sign_up/signup_cubit/sign_up_cubit.dart';

class App extends StatelessWidget {
  const App({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpCubit())
      ],
      child: MaterialApp(
        title: 'Vooms',
        theme: ThemeData(
          primarySwatch: UIColorConstant.materialPrimaryBlue,
          hintColor: UIColorConstant.accentGrey1,
          errorColor: UIColorConstant.primaryRed,
          fontFamily: GoogleFonts.dmMono().toString()
        ),
        home: const SignUpPage(),
      ),
    );
  }
}