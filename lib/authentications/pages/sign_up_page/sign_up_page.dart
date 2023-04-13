import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/authentications/auth_helpers/wording_auth_constants.dart';
import 'package:vooms/authentications/pages/blocs/signup_cubit/sign_up_cubit.dart';
import 'package:vooms/shareds/components/m_filled_button.dart';
import 'package:vooms/shareds/components/m_outline_button.dart';
import 'package:vooms/shareds/components/m_text_field.dart';
import 'package:vooms/shareds/general_helper/ui_asset_constant.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignUpCubit, SignUpState>(listener: (context, state) {
        if (state.status == FormzStatus.submissionFailure) {
          const snackBar = SnackBar(
            content: Text('Yay! A SnackBar!'),
          );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }, builder: (context, state) {
        return SafeArea(
            child: Form(
          key: _formKey,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 100, bottom: 20, top: 20),
                child: Text(
                  "Daftar sekarang, untuk mulai belajar skill baru.",
                  style: GoogleFonts.dmMono().copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ),
              MtextField(
                textInputAction: TextInputAction.next,
                hintText: "ex: Thomas Alva Edison",
                isShakeErrorAnimationActive: true,
                labelText: WordingAuthConstants.labelFullNameTextField,
                controller: _fullNameController,
                borderWidth: 2,
                onChanged: (value) =>
                    context.read<SignUpCubit>().fullNameChanged(value),
                errorText: state.fullName.pure
                    ? null
                    : state.fullName.validator(state.fullName.value),
                isLabelRequired: true,
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
                    context.read<SignUpCubit>().emailChanged(value),
                errorText:
                    state.email.invalid ? "The email is not valid." : null,
                isLabelRequired: true,
              ),
              const SizedBox(height: 5.0),
              MtextField(
                textInputAction: TextInputAction.next,
                hintText: "ex: 0899xxxxxx",
                isShakeErrorAnimationActive: true,
                labelText: WordingAuthConstants.labelPhoneNumberTextField,
                controller: _phoneController,
                textInputType: TextInputType.number,
                borderWidth: 2,
                onChanged: (value) =>
                    context.read<SignUpCubit>().phoneNumberChanged(value),
                errorText: state.phoneNumber.invalid
                    ? "The phone is not valid."
                    : null,
                isLabelRequired: true,
              ),
              const SizedBox(height: 5.0),
              MtextField(
                textInputAction: TextInputAction.next,
                hintText: "ex: **********",
                isSecurity: state.isSecurity,
                isShakeErrorAnimationActive: true,
                labelText: WordingAuthConstants.labelPasswordTextField,
                controller: _passwordController,
                borderWidth: 2,
                onChanged: (value) =>
                    context.read<SignUpCubit>().passwordChanged(value),
                errorText: state.fullName.pure
                    ? null
                    : state.password.validator(state.password.value),
                isLabelRequired: true,
                trailingChild: IconButton(
                    onPressed: () {
                      context.read<SignUpCubit>().onSecureOnChanged();
                    },
                    icon: const Icon(
                      Icons.security,
                      color: Colors.red,
                    )),
              ),
              const SizedBox(height: 5.0),
              MtextField(
                textInputAction: TextInputAction.done,
                hintText: "ex: **********",
                isSecurity: true,
                isShakeErrorAnimationActive: true,
                labelText: WordingAuthConstants.labelConfirmPasswordTextField,
                controller: _confirmPasswordController,
                borderWidth: 2,
                onChanged: (value) =>
                    context.read<SignUpCubit>().confirmPasswordChanged(value),
                errorText: state.confirmPassword.invalid
                    ? "The password is not valid."
                    : null,
                isLabelRequired: true,
              ),
              const SizedBox(height: 32.0),
              MfilledButton(
                width: double.infinity,
                height: 45,
                backgroundColor: state.status.isInvalid || state.status.isPure
                    ? UIColorConstant.nativeGrey
                    : UIColorConstant.primaryBlue,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                onPressed: () async {
                  await context.read<SignUpCubit>().signUp();
                },
                text: 'Daftar Sekarang',
              ),
              const SizedBox(height: 5.0),
              Center(
                child: Text('Atau buat akun dengan',
                    style:
                        GoogleFonts.dmMono(color: Colors.grey, fontSize: 13)),
              ),
              const SizedBox(height: 5.0),
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
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sudah mempunyai akun?",
                        style: GoogleFonts.dmMono(
                            color: Colors.black, fontSize: 13)),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Login!",
                      style: GoogleFonts.dmMono(
                          color: UIColorConstant.primaryGreen,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
      }),
    );
  }
}
