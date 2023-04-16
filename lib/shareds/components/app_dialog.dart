import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDialog {
  static void snackBarModal(BuildContext context,
      {required String message, String? actionLabel, Function()? onPressed}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: GoogleFonts.dmMono(),
      ),
      action: SnackBarAction(
        label: 'Coba Lagi',
        onPressed: () {
          onPressed != null ? onPressed() : null;
        },
      ),
    ));
  }
}
