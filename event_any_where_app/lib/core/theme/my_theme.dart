import 'package:flutter/material.dart';

class MyTheme {
  static var primaryColor = Color(0xFFF9742A);
  static var white = Colors.white;
  static var grey = Colors.grey;
  static var black = Colors.black;
  static var customBlue = Color.fromARGB(255, 228, 83, 5);
  static var customLightBlue = Color.fromARGB(255, 245, 132, 71);
  static var customRed = Color(0xFFF0635A);
  static var customYellowWithOrangeShade = Color(0xFFF59762);

  static var foodTabItemColor = Color(0xFF29D697);

  static var customBlue1 = Color(0xFFF9742A);
  static var inviteButtonColor = Color.fromARGB(255, 245, 132, 71);
  static const bottomBarBgColor = Color.fromARGB(255, 16, 20, 27);
  static var inviteTheFriendContainerColor = LinearGradient(
    colors: [
      Color.fromARGB(255, 0, 0, 0),
      Color(0xFFFFD54F),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static var going = LinearGradient(
    colors: [
      // Màu trắng
      Color.fromARGB(255, 0, 0, 0),
      Color.fromARGB(255, 32, 32, 32),
      Color.fromARGB(255, 51, 51, 51),
      Color.fromARGB(255, 63, 63, 63),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static var backgroundcolor = Color(0xFF1A1F28);
}

class AppTextStyles {
  static const heading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  static const appbarText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const description = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static const body = TextStyle(
    fontSize: 16,
    color: Colors.white70,
  );
}
