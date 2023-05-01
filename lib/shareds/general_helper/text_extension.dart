import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

extension DmMonos on Text {
   Text toNormalText({Color? color = UIColorConstant.nativeBlack, double? fontSize}){
    return Text(this.data ?? "", style:  GoogleFonts.dmMono(fontWeight: FontWeight.w500, color: color, fontSize: fontSize),);
   }

   Text toThinText({Color? color = UIColorConstant.nativeBlack, double? fontSize}){
    return Text(this.data ?? "", style: GoogleFonts.dmMono(fontWeight: FontWeight.w100, color: color, fontSize: fontSize),);
   }

   Text toBoldText({Color? color = UIColorConstant.nativeBlack, double? fontSize}){
    return Text(this.data ?? "", style: GoogleFonts.dmMono(fontWeight: FontWeight.bold, color: color, fontSize: fontSize),);
   }
}