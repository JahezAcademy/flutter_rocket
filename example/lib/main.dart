import 'package:flutter/material.dart';
import 'Views/CounterView.dart';
//import 'Views/PostView.dart';

void main() {
  runApp(MyApp());  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVR Package',
      theme: ThemeData(
        primaryColor: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

    
      home: MyHomePage(title: 'MVR Package'),
    );
  }
}
