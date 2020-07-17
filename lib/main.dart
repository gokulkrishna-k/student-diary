import 'package:flutter/material.dart';
import 'home_page.dart';
 void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Work Manager',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor:Colors.cyan,
          accentColor: Colors.cyanAccent,
    
          cardColor:Colors.black,

        ),
        home: HomePage());
  }
}
