import 'dart:async';
import 'package:esp8266_with_firebase/screens/put_select_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Template/customText.dart';
import '../Template/customTextStyle.dart';
import '../config/globalStaticVariable.dart';

class WashScreen extends StatefulWidget {
  const WashScreen({super.key});

  static const routeName = '/wash_screen';

  @override
  State<WashScreen> createState() => _WashScreenState();
}

class _WashScreenState extends State<WashScreen> {
  bool _isWeightValid = false;
  Future<void> updateWeightValid(double weightValue) async {
    DatabaseReference weightRef = FirebaseDatabase.instance.ref("weight");
    if (weightValue <= GlobalStaticVariable.WEIGHT_VALID_STANDARD){
      _isWeightValid = true;
    } else {
      _isWeightValid = false;
    }
    await weightRef.update({
      "value": weightValue,
      "valid": _isWeightValid
    });
  }

  Widget validResult(){
    if (_isWeightValid){
      return Column(
        children: [
          Text(
              CustomText.washValid,
              style : CustomTextStyle.mainStyle
          ),
          TextButton(
              onPressed: (){
                Navigator.of(context).pushNamed(PutScreen.routeName);
                },
              child: Text("다음으로", style: CustomTextStyle.buttonStyle)
          )
        ],
      );
    } else {
      return Text(
          CustomText.washInvalid,
          style : CustomTextStyle.mainStyle
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance.ref("weight").onChildChanged,
        builder: (context, AsyncSnapshot<DatabaseEvent> eventSnapshot){
          List<Widget> children;
          if(eventSnapshot.hasData){
            String? key = eventSnapshot.data!.snapshot.key;
            if (key == "value"){
              double data = eventSnapshot.data!.snapshot.value as double;
              updateWeightValid(data);
            }
            children = <Widget>[
              validResult(),
            ];
          } else if (eventSnapshot.hasError){
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${eventSnapshot.error}'),
                    ),
                  ];
                } else {
                  children = <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                          CustomText.washInfo,
                          style: CustomTextStyle.mainStyle
                      ),
                    ),
                    SizedBox(
                      child: Image.asset('assets/images/mongmong.png'),
                    ),
                  ];
                }
                return Scaffold(
                  body: Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: children,
                    )
                  ),
                );
        });
  }
}