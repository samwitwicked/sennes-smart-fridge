import 'package:flutter/material.dart';
import 'start_page.dart';

void main() => runApp(new SennesApp());

class SennesApp extends StatelessWidget {
  // This widget is the root of your application.
  static const Color primaryColor = Colors.indigo;
  static const Color accentColor = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'SenneS',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: primaryColor,
        scaffoldBackgroundColor: Colors.white,
        buttonColor: accentColor,
        accentColor: accentColor,
        brightness: Brightness.light,
        buttonTheme: ButtonThemeData(
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          textTheme: ButtonTextTheme.primary,
        ),
        iconTheme: IconThemeData(
          color: Colors.grey.shade700,
        ),

      ),
      home: new StartPage(title: 'SenneS'),
      // home: new ScanPage(),
    );
  }
}
