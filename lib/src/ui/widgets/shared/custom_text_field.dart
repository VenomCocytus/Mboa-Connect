import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mboa_connect/styles/colors.dart';
import 'package:mboa_connect/styles/themes.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final Function(String val) onChanged;
  final double height;
  final TextInputAction textInputAction;

  const CustomTextField({
    required this.hint,
    this.height = 54.0,
    required this.onChanged,
    required this.textInputAction,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextField(
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        textInputAction: textInputAction,
        cursorColor: kPrimary,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 8.0,
          ),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
      decoration: BoxDecoration(
          color: isLightTheme(context) ? Colors.white : kBubbleDark,
          borderRadius: BorderRadius.circular(45.0),
          border: Border.all(
            color:
            isLightTheme(context) ? Color(0xFFC4C4C4) : Color(0xFF393737),
            width: 1.5,
          )),
    );
  }
}