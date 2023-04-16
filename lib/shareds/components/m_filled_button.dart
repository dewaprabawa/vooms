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
      this.height = 0,
      this.width = double.infinity,
      this.textColor,
      this.textSize = 13,
      this.trailingChild = const SizedBox.shrink()
      })
      : super(key: key);
  final void Function()? onPressed;
  final String text;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final double width;
  final double height;
  final Color? textColor;
  final double textSize;
  final Widget trailingChild;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              fixedSize: Size(width, height),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center
            ,children: [
            Text(
            text,
            style: GoogleFonts.dmMono(
                color: textColor ?? UIColorConstant.nativeWhite,
                fontSize: textSize),
          ),
          const SizedBox(width: 10,),
          trailingChild,
          ],)),
    );
  }
}
