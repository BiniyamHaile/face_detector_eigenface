import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget appText({
  required String text , 
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.normal, 
  Color color  = Colors.white, 
  String fontFamily = 'OpenSans'



})=> Text(text , 
        style: TextStyle(
          fontSize: fontSize, 
          color: color, 
          fontWeight:  fontWeight, 
          fontFamily: fontFamily
        ),
);