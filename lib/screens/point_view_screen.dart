import 'dart:async';

import 'package:esp8266_with_firebase/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../Template/customTextStyle.dart';

class PointViewScreen extends StatefulWidget {
  const PointViewScreen({super.key});

  static const routeName = '/point_view_screen';

  @override
  State<PointViewScreen> createState() => _PointViewScreenState();
}

class _PointViewScreenState extends State<PointViewScreen> {
  int count_left = 5;

  @override
  void initState(){
    Timer.periodic((Duration(seconds: 1)),(timer){
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
    final userStamp = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Text(
         "적립이 완료되었습니다. 이용해주셔서 감사합니다.",
         style: CustomTextStyle.mainStyle,),
         Text(
          "현재 스탬프 개수: $userStamp개",
           style: CustomTextStyle.buttonStyle,
         ),
         Text(
           "$count_left초 후 홈화면으로 돌아갑니다.",
           style: CustomTextStyle.mainStyle
         ),
       ]
      ),
    );
  }
}
