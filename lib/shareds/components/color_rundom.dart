import 'dart:math';

import 'package:flutter/material.dart';

extension ColorExtension on Color {
  static Random _random = Random();

  static Color random() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }
}
