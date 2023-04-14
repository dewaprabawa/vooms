import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:vooms/authentications/pages/blocs/app_state_cubit/app_state_cubit.dart';
import 'package:vooms/authentications/pages/blocs/signin_cubit/sign_in_cubit.dart';
import 'package:vooms/authentications/pages/blocs/signup_cubit/sign_up_cubit.dart';
import 'package:vooms/authentications/pages/sign_in_page/sign_in_page.dart';
import 'package:vooms/authentications/pages/sign_up_page/sign_up_page.dart';
import 'package:vooms/authentications/repository/auth_repository.dart';
import 'package:vooms/authentications/repository/auth_service_impl.dart';
import 'package:vooms/authentications/repository/user_data_local_impl.dart';
import 'package:vooms/authentications/repository/user_data_remote_impl.dart';
import 'package:vooms/bottom_nav_bar/main_bottom_nav.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _authRepository = AuthRepositoryImpl(
      AuthServicesImpl(FirebaseAuth.instance, GoogleSignIn()),
      UserDataRemoteImpl(FirebaseFirestore.instance),
      UserDataLocalImpl(Hive.box("user_data")));

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (context) => _authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SignUpCubit(_authRepository)),
          BlocProvider(create: (context) => SignInCubit(_authRepository)),
          BlocProvider(create: (context) => AppStateCubit(_authRepository)),
        ],
        child: MaterialApp(
          title: 'Vooms',
          theme: ThemeData(
              primarySwatch: UIColorConstant.materialPrimaryBlue,
              hintColor: UIColorConstant.accentGrey1,
              errorColor: UIColorConstant.primaryRed,
              fontFamily: GoogleFonts.dmMono().toString()),
          home: const OnStartUpPage(),
        ),
      ),
    );
  }
}

class OnStartUpPage extends StatefulWidget {
  const OnStartUpPage({super.key});

  @override
  State<OnStartUpPage> createState() => _OnStartUpPageState();
}

class _OnStartUpPageState extends State<OnStartUpPage> {

  @override
  void initState() {
    if (context.mounted) {
      context.read<AuthRepository>().listenToUserChanges().listen((event) {
        context.read<AppStateCubit>().startListentAppStateChanges(event);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (context.mounted) {
      context.read<AppStateCubit>().close();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppStateCubit, AppStateState>(
      builder: (context, state) {
        return Navigator(pages: [
          if (state.appStateStatus == AppStateStatus.initial)
            MaterialPage(
              key: const ValueKey("_startUpPage"),
              child: Scaffold(
                  body: Center(
                      child: Text(
                "Loading ...",
                style: GoogleFonts.dmMono(fontWeight: FontWeight.w600),
              ))),
            )
          else if (state.appStateStatus == AppStateStatus.authenticated)
            const MaterialPage(
              key: ValueKey("_mainHomePage"),
              child: MainBottomNav(),
            )
          else if (state.appStateStatus == AppStateStatus.notAuthenticated)
            const MaterialPage(
              key: ValueKey("_signInPage"),
              child: SignInPage(),
            ),
        ], onPopPage: (route, result) => route.didPop(result));
      },
    );
  }
}
