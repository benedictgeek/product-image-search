import 'package:flutter/material.dart';
import 'package:image_recognition/screens/identification.dart';
import 'package:image_recognition/screens/main_screen.dart';
import 'package:image_recognition/screens/product_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Recognition',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Nunito",
        primaryColor: Color(0xff5A5DD3),
        textTheme: Theme.of(context).textTheme.copyWith(
          body1: TextStyle(
            fontSize: 13,
          ),
          body2: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400
          ),
          headline: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold
          )
        )
      ),
      // home: MainScreen(),
      // home: IndentificationScreen(),
      home: ProductScreen(),
    );
  }
}
