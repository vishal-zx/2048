import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

void main() {
  // SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(                                                                        
        primarySwatch: Colors.blue,
        fontFamily: 'StarJedi'
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
