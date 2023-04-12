import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/shareds/general_helper/ui_asset_constant.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class MoutlineButoon extends StatelessWidget {
  const MoutlineButoon(
      {Key? key,
      required this.text,
      this.margin = const EdgeInsets.symmetric(horizontal: 20),
      this.height = 0,
      this.width = double.infinity,
      this.onPressed,
      this.textColor,
      this.textSize = 13, 
      this.leadingChild, 
      this.trailingChild,
      })
      : super(key: key);
  final EdgeInsetsGeometry margin;
  final double height;
  final double width;
  final void Function()? onPressed;
  final String text;
  final Color? textColor;
  final double textSize;
  final Widget? trailingChild;
  final Widget? leadingChild;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(width, height),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: onPressed,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
         Padding(
           padding: EdgeInsets.only(right: leadingChild == null ? 0.0 : 10),
           child: leadingChild,
         ),
          Text(text,
              style: GoogleFonts.dmMono(
                  color: textColor ?? UIColorConstant.nativeGrey,
                  fontSize: textSize)),
                  trailingChild ?? const SizedBox.shrink(),
        ]),
      ),
    );
  }
}
