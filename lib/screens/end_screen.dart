import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Template/customTextStyle.dart';
import 'HomeScreen.dart';

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
        timer.cancel();
        Navigator.pushNamed(context, HomeScreen.routeName);
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            "이용해주셔서 감사합니다. $count_left초 후 홈화면으로 돌아갑니다.",
            style: CustomTextStyle.mainStyle,
          ),
        ),
      )
    );
  }


}
