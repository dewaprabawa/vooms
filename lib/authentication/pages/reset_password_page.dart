import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/authentication/pages/blocs/signin_cubit/sign_in_cubit.dart';
import 'package:vooms/shareds/components/app_dialog.dart';
import 'package:vooms/shareds/components/m_filled_button.dart';
import 'package:vooms/shareds/components/m_text_field.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final TextEditingController _resetPasswordController;

  @override
  void initState() {
    _resetPasswordController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _resetPasswordController.clear();
    _resetPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIColorConstant.accentGrey2,
        elevation: 0.0,
      ),
      body: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          if(state.status.isSubmissionSuccess){
            AppDialog.snackBarModal(context, 
            message: "Link ganti password telah di kirim ke email ${_resetPasswordController.text}.",
            actionLabel: "OK",
             onPressed: (){
              Navigator.pop(context);
            });
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.0,
                  ),
                  Text(
                    "Reset Password",
                    style: GoogleFonts.dmMono(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Masukan email anda untuk mengganti password.",
                    style: GoogleFonts.dmMono(fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MtextField(
                     borderColor: UIColorConstant.primaryGreen,
                     borderWidth: 1,
                      margin: const EdgeInsets.all(0),
                      hintText: "ex: Thomas Alva Edison",
                      onChanged: (value) {},
                      controller: _resetPasswordController),
                       const SizedBox(
                    height: 10,
                  ),
                  MfilledButton(
                      height: 40, onPressed: () {
                         if(_resetPasswordController.text.isEmpty){
                          return AppDialog.snackBarModal(context, message: "Email tidak boleh kosong.");
                         }
                        context.read<SignInCubit>().resetPassword(_resetPasswordController.text);
                      }, text: "Ganti Password")
                ]),
          ),
        ),
      ),
    );
  }
}
