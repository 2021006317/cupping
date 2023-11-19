import 'dart:async';

import 'package:esp8266_with_firebase/screens/HomeScreen.dart';
import 'package:flutter/material.dart';

import '../Template/customTextStyle.dart';

class EndOfGetStampThanks extends StatefulWidget {
  const EndOfGetStampThanks({super.key});

  static const routeName = '/EndOfGetStampThanks';

  @override
  State<EndOfGetStampThanks> createState() => _EndOfGetStampThanksState();
}

class _EndOfGetStampThanksState extends State<EndOfGetStampThanks> {
  int count_left = 5;

  @override
  void initState(){
    Timer.periodic((const Duration(seconds: 1)),(timer){
      setState(() {
        count_left -=1;
      });
      if (count_left == 0){
        timer.cancel();
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    count_left=0;
  }

  @override
  Widget build(BuildContext context) {
    final userStamp = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
          )
        ),
      ),
    );
  }
}
