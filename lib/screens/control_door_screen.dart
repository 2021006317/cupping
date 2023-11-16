import 'package:esp8266_with_firebase/screens/end_screen.dart';
import 'package:esp8266_with_firebase/screens/home_screen.dart';
import 'package:esp8266_with_firebase/screens/point_get_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Template/customTextStyle.dart';

class ControlDoorScreen extends StatefulWidget {
  const ControlDoorScreen({super.key});

  static const routeName = '/control_door_screen';

  @override
  State<ControlDoorScreen> createState() => _ControlDoorScreenState();
}

class _ControlDoorScreenState extends State<ControlDoorScreen> {

  Future<void> updateMovement(String movement) async {
    DatabaseReference weightRef = FirebaseDatabase.instance.ref("movement");
    await weightRef.update({
      "move" : movement
    });
  }

  void routing(int index){
    List<String> routeName = [PointScreen.routeName, EndScreen.routeName];
    Navigator.pushNamed( context, routeName[index] );
  }

  @override
  Widget build(BuildContext context) {
    updateMovement("open");
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref("movement").onChildChanged,
      builder: (context, AsyncSnapshot<DatabaseEvent> eventSnapshot){
        List<Widget> children;
        if(eventSnapshot.hasData) {
          String move = eventSnapshot.data!.snapshot.value as String;
          updateMovement(move);
          children = [
            movementStateWidget(move),
            askStampWidget()
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
          children = [
            Text(
                '컵 리드(뚜껑), 컵홀더는 모두 왼쪽의 일반쓰레기통에 버려주세요.',
                style: CustomTextStyle.mainStyle
            )
          ];
        }
        return Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            )
        );
      },
    );
  }

  Widget movementStateWidget(String move) {
    if (move == "open") {
      return Text(
          "뚜껑, 컵홀더 등을 모두 분리 후 컵을 올바른 방향으로 넣어주세요.",
          style: CustomTextStyle.mainStyle
      );
    } else {
      return Text(
          "반납이 완료되었습니다. 스탬프를 적립하시겠습니까?",
          style: CustomTextStyle.mainStyle
      );
    }
  }

  Widget askStampWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: (){routing(0);},
                child: Text("Y(적립화면으로 이동)", style: CustomTextStyle.buttonStyle)),
            TextButton(
                onPressed: (){routing(1);},
                child: Text("N(홈화면으로 이동)", style: CustomTextStyle.buttonStyle)),
          ],
      ),
    );
  }
}