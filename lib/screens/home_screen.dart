import 'package:esp8266_with_firebase/config/palette.dart';
import 'package:esp8266_with_firebase/screens/wash_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home_screen';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            const Text("환영합니다"),
            TextButton(onPressed: (){
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WashScreen(),), (route) => false);
            }, child: const Text(
              "시작하기"
            ))
          ],
        ),
    );
  }
}
