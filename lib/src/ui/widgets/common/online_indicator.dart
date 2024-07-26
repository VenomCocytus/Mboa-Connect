import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mboa_connect/styles/colors.dart';
import 'package:mboa_connect/styles/themes.dart';

class OnlineIndicator extends StatelessWidget {
  const OnlineIndicator();

  @override
  Widget build(BuildContext buildContext) {
    return Container(
      height: 15.0,
      width: 15.0,
      decoration: BoxDecoration(
        color: kIndicatorBubble,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 3.0,
          color: isLightTheme(buildContext) ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}