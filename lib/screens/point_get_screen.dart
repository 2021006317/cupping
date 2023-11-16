import 'package:cloud_firestore/cloud_firestore.dart';
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
  final maxStamp = 12;
  var _userEnterMessage='';
  bool _isButtonEnabled=false;

  void _rewarded(int phoneNumber) async{
    final userCollection = FirebaseFirestore.instance.collection("user");
    if ('$phoneNumber'.length==10){
      _isButtonEnabled = true;
      DocumentSnapshot snapshot = await userCollection.doc('$phoneNumber').get();
      if (!snapshot.exists) { // 새로운 사용자
        userCollection.doc('$phoneNumber').set(
            {
              'phoneNumber': phoneNumber,
              'created_at': Timestamp.now(),
              'stamp': 1
            }
        );
      } else{ // 기존 사용자
        if((1+snapshot['stamp'])==maxStamp){
          getNewCoupon(userCollection.doc('$phoneNumber'));
        }
        addStamp(userCollection.doc('$phoneNumber'));
      }
      _userEnterMessage = '';
      _isButtonEnabled = false;
      Navigator.of(context).pushNamed(
          PointViewScreen.routeName, 
          arguments: await userCollection.doc('$phoneNumber').get().then((value) => value['stamp'] as int));
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
                            if(value.length==11) _isButtonEnabled = true;
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
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                          onPressed: () {
                            if (_isButtonEnabled) {
                              _rewarded(int.parse(_userEnterMessage));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('전화번호 값이 유효하지 않습니다.'),
                                      content: Text('${_isButtonEnabled} : 다시 입력해주세요.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('확인'),
                                        ),
                                      ],
                                    );
                                  });
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
    userDoc.collection("alarms").add({
      'created_at' : Timestamp.now(),
      'title' : '새 쿠폰 적립 알림',
      'content' : '새로운 쿠폰이 적립되었습니다! 쿠폰함을 확인해주세요.'
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
