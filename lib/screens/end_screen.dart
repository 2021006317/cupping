import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Template/customTextStyle.dart';
import 'home_screen.dart';

class EndScreen extends StatefulWidget {
  const EndScreen({super.key});


  static const routeName = '/end_screen';

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  int count_left = 3;

  @override
  void initState(){
    Timer.periodic((const Duration(seconds: 1)),(timer){
      setState(() {
        count_left -=1;
      });
      if (count_left == 0){
        Navigator.pushNamed(context, HomeScreen.routeName);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "이용해주셔서 감사합니다. $count_left초 후 홈화면으로 돌아갑니다.",
          style: CustomTextStyle.mainStyle,
        ),
      )
    );
  }
}
