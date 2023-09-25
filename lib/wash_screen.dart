import 'dart:async';
import 'dart:convert';
import 'dart:js_util';

import 'package:esp8266_with_firebase/put_select_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import './config/globalStaticVariable.dart';
import 'model/weight.dart';

class WashScreen extends StatefulWidget {
  const WashScreen({super.key});

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

  @override
  void initState(){
    super.initState();
  }

  Widget validResult(){
    if (_isWeightValid){
      return Column(
        children: [
          Text("세척이 완료되었습니다! 다음 단계를 진행해주세요."),
          TextButton(onPressed: (){}, child: Text("다음으로"))
        ],
      );
    } else {
      return Text("세척이 마무리되지 않았습니다. 더 깨끗하게 세척해주세요.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance.ref("weight").onChildChanged,
        builder: (context, AsyncSnapshot<DatabaseEvent> eventSnapshot){
          if (eventSnapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
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
                  children = const <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    ),
                  ];
                }
                return Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  )
                );
        });
  }
}