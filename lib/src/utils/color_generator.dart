import 'dart:math';

import 'package:flutter/material.dart';

class RandomColorGenerator {
  static Random random = Random();

  static Color getColor() {
    return Color.fromARGB(
        255,
        random.nextInt(255),
        random.nextInt(255),
        random.nextInt(255)
    );
  }
}