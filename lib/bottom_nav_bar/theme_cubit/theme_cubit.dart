import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  FutureOr<void> setTheme(ThemeStatus status) {
    final lightTheme = ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: UIColorConstant.nativeWhite,
          elevation: 0.5,
          selectedLabelStyle: GoogleFonts.dmMono(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.dmMono(fontWeight: FontWeight.w400),
          selectedItemColor: UIColorConstant.materialPrimaryRed,
          selectedIconTheme:
              IconThemeData(color: UIColorConstant.materialPrimaryRed),
        ),
        textTheme: TextTheme(
          displayMedium: GoogleFonts.dmMono(fontWeight: FontWeight.w500),
          displayLarge: GoogleFonts.dmMono(fontWeight: FontWeight.bold),
          displaySmall: GoogleFonts.dmMono(fontWeight: FontWeight.w100),
        ),
        iconTheme: IconThemeData(color: UIColorConstant.materialPrimaryRed),
        appBarTheme: const AppBarTheme(color: UIColorConstant.nativeWhite),
        scaffoldBackgroundColor: UIColorConstant.backgroundColorGrey,
        primarySwatch: UIColorConstant.materialPrimaryBlue,
        hintColor: UIColorConstant.nativeGrey,
        dividerColor: UIColorConstant.accentGrey1,
        accentColor: UIColorConstant.primaryRed,
        primaryColor: UIColorConstant.primaryBlue,
        backgroundColor: UIColorConstant.nativeWhite,
        fontFamily: "dmMono");

    emit(state.copyWith(
        themeStatus: status,
        currentTheme:
            status == ThemeStatus.dark ? ThemeData.dark() : lightTheme));
  }
}
