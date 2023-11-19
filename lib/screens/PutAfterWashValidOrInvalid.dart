import 'dart:async';
import 'package:esp8266_with_firebase/screens/SelectCup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Template/customText.dart';
import '../Template/customTextStyle.dart';
import '../config/globalStaticVariable.dart';

class PutAfterWashValidOrInvalid extends StatefulWidget {
  const PutAfterWashValidOrInvalid({super.key});

  static const routeName = '/PutAfterWashValidOrInvalid';

  @override
  State<PutAfterWashValidOrInvalid> createState() => _PutAfterWashValidOrInvalidState();
}

class _PutAfterWashValidOrInvalidState extends State<PutAfterWashValidOrInvalid> {
  bool _isWeightValid = false;

  Future<void> updateWeightValid(double weightValue) async {
    DatabaseReference weightRef = FirebaseDatabase.instance.ref("weight");
    if (weightValue <= GlobalStatic.WEIGHT_VALID_STANDARD){
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
              style : CustomTextStyle.mainStyle,
            textAlign: TextAlign.center,
          ),
          TextButton(
              onPressed: (){
                Navigator.of(context).pushNamed(SelectCup.routeName);
                },
              child: Text("다음으로", style: CustomTextStyle.buttonStyle)
          )
        ],
      );
    } else {
      return Text(
          CustomText.washInvalid,
          style : CustomTextStyle.mainStyle,
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      child: StreamBuilder(
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
                            style: CustomTextStyle.mainStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        child: Image.asset('assets/images/mongmong.png'),
                      ),
                    ];
                  }
                  return Scaffold(
                    body: Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.all(10.0),
                      child: Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: children,
                        )
                      ),
                    ),
                  );
          }),
    );
  }
}