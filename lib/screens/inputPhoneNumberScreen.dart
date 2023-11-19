import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp8266_with_firebase/screens/EndOfGetStampThanks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Template/customTextStyle.dart';

class inputPhoneNumberScreen extends StatefulWidget {
  const inputPhoneNumberScreen({super.key});

  static const routeName = '/inputPhoneNumberScreen';

  @override
  State<inputPhoneNumberScreen> createState() => _inputPhoneNumberScreenState();
}

class _inputPhoneNumberScreenState extends State<inputPhoneNumberScreen> {

  final TextEditingController _phoneNumberController = TextEditingController();
  final maxStamp = 6;
  var _userEnterMessage='';
  bool _isButtonEnabled=false;

  void _rewarded(String phoneNumber) async{
    final userCollection = FirebaseFirestore.instance.collection("user");
    if (_isButtonEnabled){
      DocumentSnapshot snapshot = await userCollection.doc(phoneNumber).get();
      if (!snapshot.exists) { // 새로운 사용자
        userCollection.doc(phoneNumber).set(
            {
              'phoneNumber': phoneNumber,
              'created_at': Timestamp.now(),
              'stamp': 1
            }
        );
      } else{ // 기존 사용자
        addStamp(userCollection.doc(phoneNumber));
        if((1+snapshot['stamp'])==maxStamp){
          getNewCoupon(userCollection.doc(phoneNumber));
        }
      }
      _userEnterMessage = '';
      Navigator.of(context).pushNamed(
          EndOfGetStampThanks.routeName,
          arguments: await userCollection.doc(phoneNumber).get().then((value) => value['stamp'] as int));
    }
  }
  
  @override
  void initState(){
    _phoneNumberController.addListener(() {
      _isButtonEnabled = ((_userEnterMessage.length==11)&&!(_userEnterMessage.substring(0,3).contains("010"))) ? true : false;
    });
  }

  @override
  void dispose(){
    super.dispose();
    _isButtonEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("적립할 핸드폰 번호를 입력해주세요.", style: CustomTextStyle.mainStyle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: deviceWidth/2,
                      child: TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          setState(() {
                            _userEnterMessage = value;
                            if(((value.length==11)&&(_userEnterMessage.substring(0,3).contains("010")))) _isButtonEnabled = true;
                            print(_userEnterMessage);
                            print(_isButtonEnabled);
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
                            hintText: "010 4567 4321",
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
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                          onPressed: () {
                            print(_isButtonEnabled);
                            if (!_isButtonEnabled){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: const Text('전화번호 값이 유효하지 않습니다.'),
                                      content: const Text('010으로 시작하는 전화번호를 입력해주세요.\n이후 스탬프 조회를 위한 본인확인에 이용됩니다.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('확인'),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            } else{
                              _rewarded(_userEnterMessage);
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

  void getNewCoupon(DocumentReference userDoc){
    userDoc.collection("coupons").add({
      'expired_at' : Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
      'content' : '스탬프 $maxStamp개 적립 기프티콘 교환권'
    });
    userDoc.collection("history").add({
      'created_at' : Timestamp.now(),
      'title' : '스탬프 $maxStamp개 적립 기프티콘 교환권 발급',
      'content' : '새로운 쿠폰이 발급되었습니다! 만료일은 ${DateTime.now().add(const Duration(days: 30)).toString().substring(0,10)}입니다.'
    });
    userDoc.collection("alarms").add({
      'created_at' : Timestamp.now(),
      'title' : '새 쿠폰 발급 알림',
      'content' : '새로운 쿠폰이 발급되었습니다! 쿠폰함을 확인해주세요.'
    });
    userDoc.update({
      'stamp' : 0
    });
  }

  void addStamp(DocumentReference userDoc){
    userDoc.update({
      'stamp' : FieldValue.increment(1)
    });
    userDoc.collection("history").add(
        {
          'created_at' : Timestamp.now(),
          'title' : '스탬프 적립',
          'content' : '스탬프 1개가 적립되었습니다.'
        }
    );
  }
}
