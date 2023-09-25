import 'package:esp8266_with_firebase/screens/control_door_screen.dart';
import 'package:flutter/material.dart';

class PutScreen extends StatefulWidget {
  const PutScreen({super.key});

  static const routeName = '/PutScreen';
  @override
  State<PutScreen> createState() => _PutScreenState();
}

// 종이인지 플라스틱인지 고르게 한다.
class _PutScreenState extends State<PutScreen> {
  Icon? _choosed;
  List<Icon> iconList = [
    Icon(Icons.file_copy_outlined),
    Icon(Icons.coffee_outlined)
  ];

  void selected(int index){
    _choosed = iconList[index];
    Navigator.pushNamed(
        context,
        ControlDoorScreen.routeName,
        arguments: "open"
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("반납할 컵의 종류를 선택해주세요."),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){selected(0);}, icon: iconList[0]),
              IconButton(onPressed: (){selected(1);}, icon: iconList[1]),
            ],
          ),
        ],
      ),
    );
  }
}
