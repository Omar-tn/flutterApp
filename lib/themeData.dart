import 'package:flutter/material.dart';

class themeD {
  static final mainColor = Colors.blue;


  static AppBar customAppBar({
    required String title,
    Widget leading = const SizedBox
        .shrink(), // Default value for `leading` is an empty container
    List<Widget>? actions,
    Color backgroundColor = Colors.blue, // Default background color
    TextStyle titleTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    bool centerTitle = true,
  }) {
    return AppBar(
      leading: leading,
      title: Text(
        title,
        style: titleTextStyle,
      ),
      actions: actions,
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
    );
  }
  
  static final darkMode = ThemeData(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[850],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
    ),

    cardTheme: CardThemeData(
      color: Colors.grey[800],

      // shape: RoundedRectangleBordxer(
      //   borderRadius: BorderRadius.circular(10),
      // ),
      // elevation: 5,
      // shadowColor: Colors.black54,
      //margin: EdgeInsets.all(10),
    ),

    listTileTheme: ListTileThemeData(
      textColor: Colors.white,
      iconColor: Colors.white,
      tileColor: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 20),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      // filled: true,
      fillColor: Colors.grey[700],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),

        // borderSide: BorderSide.
      ),
      labelStyle: TextStyle(color: Colors.white, fontSize: 18),
      hintStyle: TextStyle(color: Colors.white70, fontSize: 18),
    ),
  );

  // ======================================================================================
  //****************************************************************************************
  //////////////////////////////////////////////////////////////////////////////////////////////////////

  // ======================================================================================

  static final ThemeData lightMode = ThemeData(
    primaryColor: Colors.teal,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: mainColor,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
      
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10),
      // ),
      // elevation: 5,
      // shadowColor: Colors.black54,
      // margin: EdgeInsets.all(10),
    ),
    listTileTheme: ListTileThemeData(
      textColor: Colors.black,
      iconColor: Colors.black,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 20),



      bodySmall: TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),

      headlineSmall: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),

    ),

    inputDecorationTheme: InputDecorationTheme(
      // filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: themeD.mainColor, // Button background color
        iconColor: Colors.black,
        foregroundColor: Colors.black,
        // Background color
        textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),

        // Text style
        // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Button shape
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding
      ),
    ),
  );
}
