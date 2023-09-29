import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp8266_with_firebase/screens/home_screen.dart';
import 'package:esp8266_with_firebase/screens/point_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Template/customTextStyle.dart';

class PointScreen extends StatefulWidget {
  const PointScreen({super.key});

  static const routeName = '/point_get_screen';

  @override
  State<PointScreen> createState() => _PointScreenState();
}

class _PointScreenState extends State<PointScreen> {

  final TextEditingController _phoneNumberController = TextEditingController();
  var _userEnterMessage='';
  bool _isButtonEnabled=false;

  void _rewarded(int phoneNumber) async{
    final userCollection = FirebaseFirestore.instance.collection("user");
    int userStamp = 1;
    if ('$phoneNumber'.length==10){
      _isButtonEnabled = true;
      DocumentSnapshot snapshot = await userCollection.doc('$phoneNumber').get();
      if (snapshot.exists){
        final userDoc = userCollection.doc('$phoneNumber');
        userStamp = 1 + (snapshot['stamp'] as int);
        userDoc.update({
          'stamp' : userStamp
        });
      } else {
        userCollection.doc('$phoneNumber').set(
          {
            'phoneNumber' : phoneNumber,
            'created_at' : Timestamp.now(),
            'stamp' : userStamp
          }
        );
      }
      _userEnterMessage = '';
      _isButtonEnabled = false;
      Navigator.of(context).pushNamed(
          PointViewScreen.routeName,
          arguments: userStamp); // number도 같이 넘겨주고 싶음.
    }
  }
  
  @override
  void initState(){
    _phoneNumberController.addListener(() {
      _isButtonEnabled = (_userEnterMessage.length==11) ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Center(
          child: Container(
            width: deviceWidth/2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("적립할 핸드폰 번호를 입력해주세요.", style: CustomTextStyle.mainStyle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: deviceWidth/3,
                      child: TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          setState(() {
                            _userEnterMessage = value;
                          });
                        },
                        textAlignVertical: TextAlignVertical.center,
                        style: CustomTextStyle.buttonStyle,
                        cursorColor: Colors.purpleAccent,
                        validator: (String? value){
                          if(value!.isEmpty){
                            return "전화번호를 입력해주세요.";
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        decoration: const InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.phone_android, size: 40,),
                            ),
                            prefixIconColor: Colors.purple,
                            hintText: "전화번호",
                            hintStyle: TextStyle(color: Colors.grey),
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                color: Colors.purpleAccent,
                                width: 3,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                color: Colors.purpleAccent,
                                width: 3,
                              ),
                            )
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                          onPressed: () {
                            if (_isButtonEnabled) {
                              _rewarded(int.parse(_userEnterMessage));
                            }
                          },
                          child: Text('완료', style: CustomTextStyle.buttonStyle)
                      ),
                    )
                  ],
                ),
              ],
      ),
          ),
        ),
    );
  }
}
