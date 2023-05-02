import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/authentication/pages/blocs/app_state_cubit/app_state_cubit.dart';
import 'package:vooms/authentication/pages/blocs/signin_cubit/sign_in_cubit.dart';
import 'package:vooms/authentication/pages/blocs/signup_cubit/sign_up_cubit.dart';
import 'package:vooms/authentication/pages/sign_in_page.dart';
import 'package:vooms/authentication/repository/auth_repository.dart';
import 'package:vooms/bottom_nav_bar/main_bottom_nav.dart';
import 'package:vooms/bottom_nav_bar/theme_cubit/theme_cubit.dart';
import 'package:vooms/dependency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<SignInCubit>()),
        BlocProvider(create: (context) => sl<SignUpCubit>()),
        BlocProvider(create: (context) => sl<AppStateCubit>()),
        BlocProvider(create: (context) => sl<ThemeCubit>()..setTheme(ThemeStatus.light)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Vooms',
            theme: state.currentTheme,
            home: const OnStartUpPage(),
          );
        },
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
      sl<AuthRepository>().listenAuthChanges().listen((event) {
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
