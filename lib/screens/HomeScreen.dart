import 'package:esp8266_with_firebase/config/palette.dart';
import 'package:esp8266_with_firebase/screens/PutAfterWashValidOrInvalid.dart';
import 'package:flutter/material.dart';

import '../Template/customText.dart';
import '../Template/customTextStyle.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/HomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                  CustomText.home,
                  style: CustomTextStyle.mainStyle
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pushNamed(PutAfterWashValidOrInvalid.routeName);
                    },
                  child: Text(
                      "시작하기",
                      style: CustomTextStyle.buttonStyle
                  )
              )
            ],
          ),
      ),
    );
  }
}
