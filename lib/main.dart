import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(                                                                        
        primarySwatch: Colors.blue,
      ),
      home: Home(title: '2048'),
    );
  }
}
