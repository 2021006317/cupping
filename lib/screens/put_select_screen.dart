import 'package:esp8266_with_firebase/screens/control_door_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Template/customTextStyle.dart';

class PutScreen extends StatefulWidget {
  const PutScreen({super.key});

  static const routeName = '/PutScreen';
  @override
  State<PutScreen> createState() => _PutScreenState();
}

// 종이인지 플라스틱인지 고르게 한다.
class _PutScreenState extends State<PutScreen> {

  /* Cup 종류 */
  Widget cupProfileButton({required int index}){
    String sort;
    String imageLink;
    if (index==0) {
      sort = "종이";
      imageLink = 'assets/images/mongmong.png';
    } else if (index==1) {
      sort = "플라스틱";
      imageLink = 'assets/images/mongmong.png';
    } else {
      sort = "기타";
      imageLink = 'assets/images/mongmong.png';
    }

    void routing(int index){
      DatabaseReference weightRef = FirebaseDatabase.instance.ref("movement");
      weightRef.update({
        "move" : "open"
      });
      Navigator.pushNamed(
          context,
          ControlDoorScreen.routeName
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
      child: InkWell(
        onTap: (){routing(index);},
        child: Container(
          alignment: Alignment.center,
                child: Column(
                    children: [
                      Image.asset(imageLink, fit: BoxFit.fill),
                      Text(sort, style: CustomTextStyle.buttonStyle),
                    ]
                )
            )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
              "반납할 컵의 종류를 선택해주세요.",
              style: CustomTextStyle.mainStyle
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cupProfileButton(index: 0),
              cupProfileButton(index: 1)
            ],
          ),
        ],
      ),
    );
  }
}
