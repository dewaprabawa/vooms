import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/authentication/auth_helpers/wording_auth_constants.dart';
import 'package:vooms/authentication/pages/blocs/signin_cubit/sign_in_cubit.dart';
import 'package:vooms/authentication/pages/blocs/signup_cubit/sign_up_cubit.dart';
import 'package:vooms/authentication/pages/components/on_will_bloc_pop.dart';
import 'package:vooms/authentication/pages/reset_password_page.dart';
import 'package:vooms/authentication/pages/sign_up_page.dart';
import 'package:vooms/authentication/repository/auth_repository.dart';
import 'package:vooms/shareds/components/app_dialog.dart';
import 'package:vooms/shareds/components/m_filled_button.dart';
import 'package:vooms/shareds/components/m_outline_button.dart';
import 'package:vooms/shareds/components/m_text_field.dart';
import 'package:vooms/shareds/general_helper/ui_asset_constant.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _startRememberMe();
    super.initState();
  }

  void _startRememberMe() {
    Future.microtask(() async {
      final cacheCredential =
          await context.read<AuthRepository>().getUserCredentials();
      debugPrint("==iSREMEBER ${cacheCredential["rememberMe"]}");
      if (cacheCredential.isNotEmpty && cacheCredential["rememberMe"]) {
        _emailController.text = cacheCredential["email"];
        _passwordController.text = cacheCredential["password"];
        context.read<SignInCubit>().emailChanged(_emailController.text);
        context.read<SignInCubit>().passwordChanged(_passwordController.text);
        context.read<SignInCubit>().isRememberMe(true);
      } else {
        context.read<SignInCubit>().isRememberMe(false);
      }
    });
  }

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          AppDialog.snackBarModal(context, message: state.errorMessage);
        }
        if (state.isRememberMe) {}
      },
      builder: (context, state) {
        return OnWillBlokPop(
          onWillPop: false,
          child: Scaffold(
            body: SafeArea(
                child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 100, bottom: 20, top: 20),
                  child: Text(
                    "Selamat datang, ayo mulai belajar skill baru.",
                    style: GoogleFonts.dmMono().copyWith(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 5.0),
                MtextField(
                  textInputAction: TextInputAction.next,
                  hintText: "ex: Thomas@mail.com",
                  isShakeErrorAnimationActive: true,
                  labelText: WordingAuthConstants.labelEmailTextField,
                  controller: _emailController,
                  borderWidth: 2,
                  onChanged: (value) =>
                      context.read<SignInCubit>().emailChanged(value),
                  errorText:
                      state.email.invalid ? "The email is not valid." : null,
                  isLabelRequired: true,
                ),
                const SizedBox(height: 5.0),
                MtextField(
                  isSecurity: state.isSecurity,
                  textInputAction: TextInputAction.next,
                  hintText: "ex: ***********",
                  isShakeErrorAnimationActive: true,
                  labelText: WordingAuthConstants.labelPasswordTextField,
                  controller: _passwordController,
                  borderWidth: 2,
                  trailingChild: IconButton(
                      onPressed: () {
                        context.read<SignInCubit>().onSecureOnChanged();
                      },
                      icon: const Icon(
                        Icons.security,
                        color: UIColorConstant.primaryRed,
                      )),
                  onChanged: (value) =>
                      context.read<SignInCubit>().passwordChanged(value),
                  errorText: state.password.invalid
                      ? "The password is not valid."
                      : null,
                  isLabelRequired: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    children: [
                      Checkbox(
                          activeColor: UIColorConstant.primaryBlue,
                          value: state.isRememberMe,
                          onChanged: (value) {
                            context.read<SignInCubit>().isRememberMe(value!);
                          }),
                      Text("Ingat saya?",
                          style: GoogleFonts.dmMono(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      const Spacer(),
                      GestureDetector(
                        onTapUp: (detail){
                          var route = CupertinoPageRoute(builder: (context) => const ResetPasswordPage());
                          Navigator.push(context, route);
                        },
                        child: Text("Lupa password",
                            style: GoogleFonts.dmMono(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.underline,
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                MfilledButton(
                  width: double.infinity,
                  height: 45,
                  backgroundColor: state.status.isInvalid || state.status.isPure
                      ? UIColorConstant.nativeGrey
                      : UIColorConstant.primaryBlue,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  trailingChild: state.status.isSubmissionInProgress
                      ? const CircularProgressIndicator.adaptive()
                      : const SizedBox.shrink(),
                  onPressed: context.read<SignInCubit>().isStillPure
                      ? null
                      : () async {
                          await context.read<SignInCubit>().signInUser();
                        },
                  text: 'Masuk Sekarang',
                ),
                const SizedBox(height: 15.0),
                Center(
                  child: Text('Atau buat akun dengan',
                      style:
                          GoogleFonts.dmMono(color: Colors.grey, fontSize: 13)),
                ),
                const SizedBox(height: 15.0),
                MoutlineButoon(
                  width: double.infinity,
                  height: 45,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  text: "Google",
                  leadingChild: Image.asset(UIAssetConstants.googleButtonImage),
                  onPressed: () async {
                    await context.read<SignUpCubit>().loginWithGoogle();
                  },
                ),
                TextButton(
                  onPressed: () {
                    var route = CupertinoPageRoute(
                        builder: ((context) => const SignUpPage()));
                    Navigator.of(context).push(route);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Belum mempunyai akun?",
                          style: GoogleFonts.dmMono(
                              color: Colors.black, fontSize: 13)),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Buat sekarang!",
                        style: GoogleFonts.dmMono(
                            color: UIColorConstant.primaryGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            )),
          ),
        );
      },
    );
  }
}
