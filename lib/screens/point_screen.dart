import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PointScreen extends StatefulWidget {
  const PointScreen({super.key});

  static const routeName = '/point_screen';

  @override
  State<PointScreen> createState() => _PointScreenState();
}

class _PointScreenState extends State<PointScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("적립할 핸드폰 번호를 입력해주세요."),

        ],
      ),
    );
  }
}
