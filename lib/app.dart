import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:vooms/authentication/pages/blocs/app_state_cubit/app_state_cubit.dart';
import 'package:vooms/authentication/pages/blocs/signin_cubit/sign_in_cubit.dart';
import 'package:vooms/authentication/pages/blocs/signup_cubit/sign_up_cubit.dart';
import 'package:vooms/authentication/pages/sign_in_page/sign_in_page.dart';
import 'package:vooms/authentication/repository/auth_repository.dart';
import 'package:vooms/authentication/repository/auth_service_impl.dart';
import 'package:vooms/authentication/repository/user_data_local_impl.dart';
import 'package:vooms/authentication/repository/user_data_remote_impl.dart';
import 'package:vooms/authentication/repository/user_repository.dart';
import 'package:vooms/authentication/repository/user_repository_impl.dart';
import 'package:vooms/bottom_nav_bar/main_bottom_nav.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _authRepository = AuthRepositoryImpl(
      AuthServicesImpl(FirebaseAuth.instance, GoogleSignIn()),
      UserDataRemoteImpl(FirebaseFirestore.instance),
      UserDataLocalImpl(Hive.box("user_data")));
  final _userRepository = UserRepositoryImpl(
      UserDataRemoteImpl(FirebaseFirestore.instance),
      UserDataLocalImpl(Hive.box("user_data")));
      

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => _authRepository,
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => _userRepository,
        ),
      ],
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
    if (mounted) {
      context.read<AuthRepository>().listenToUserChanges().listen((event) {
        context.read<AppStateCubit>().startListentStateChanges(event);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      context.read<AppStateCubit>().close();
    }
    super.dispose();
  }

  MaterialPage<dynamic> _switchOnStatus(AppStateStatus status) {
    MaterialPage<dynamic> widget;
    switch (status) {
      case AppStateStatus.initial:
        widget = MaterialPage(
          key: const ValueKey("_startUpPage"),
          child: Scaffold(
              body: Center(
                  child: Text(
            "Loading ...",
            style: GoogleFonts.dmMono(fontWeight: FontWeight.w600),
          ))),
        );
        break;
      case AppStateStatus.authenticated:
        widget = const MaterialPage(
          key: ValueKey("_mainHomePage"),
          child: MainBottomNav(),
        );
        break;
      case AppStateStatus.notAuthenticated:
        widget = const MaterialPage(
          key: ValueKey("_signInPage"),
          child: SignInPage(),
        );
        break;
      default:
        widget = const MaterialPage(
          key: ValueKey("_emptyPage"),
          child: SizedBox(),
        );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppStateCubit, AppStateState>(
      builder: (context, state) {
        return Navigator(pages: [
          _switchOnStatus(state.appStateStatus),
        ], onPopPage: (route, result) => route.didPop(result));
      },
    );
  }
}
