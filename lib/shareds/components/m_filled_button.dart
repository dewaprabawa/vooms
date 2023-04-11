import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class MfilledButton extends StatelessWidget {
  const MfilledButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.margin = EdgeInsets.zero,
      this.backgroundColor,
      this.size = const Size(double.infinity, 45),
      this.textColor,
      this.textSize = 13})
      : super(key: key);
  final void Function()? onPressed;
  final String text;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final Size size;
  final Color? textColor;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: backgroundColor,
              fixedSize: size,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: onPressed,
          child: Text(
            text,
            style: GoogleFonts.dmMono(
                color: textColor ?? UIColorConstant.nativeWhite,
                fontSize: textSize),
          )),
    );
  }
}
