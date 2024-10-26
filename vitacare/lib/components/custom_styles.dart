import 'package:flutter/material.dart';

class CustomStyles {
  static TextStyle headingTextStyle(double screenWidth) {
    return TextStyle(
      fontSize: screenWidth * 0.07,
      fontWeight: FontWeight.bold,
      color: Colors.black,  // Dynamic text color
    );
  }

  static TextStyle subheadingTextStyle(double screenWidth) {
    return TextStyle(
      fontSize: screenWidth * 0.04,
      fontWeight: FontWeight.w400,
      color: Colors.black54,
    );
  }

  static TextStyle questionTextStyle(double screenWidth) {
    return TextStyle(
      fontSize: screenWidth * 0.045,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.2,
      color: Colors.black, // Color for question text
    );
  }

  static TextStyle progressTextStyle(double screenWidth) {
    return TextStyle(
      fontSize: screenWidth * 0.08,  // Large progress number
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static TextStyle subtextStyle(double screenWidth) {
    return TextStyle(
      fontSize: screenWidth * 0.035,
      fontWeight: FontWeight.w400,
      color: Colors.black54,
    );
  }
}