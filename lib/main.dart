import 'package:esp8266_with_firebase/screens/control_door_screen.dart';
import 'package:esp8266_with_firebase/screens/point_screen.dart';
import 'package:esp8266_with_firebase/screens/put_select_screen.dart';
import 'package:esp8266_with_firebase/screens/wash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';

void main() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final routes = {
      HomeScreen.routeName: (context) => const HomeScreen(),
      WashScreen.routeName: (context) => const WashScreen(),
      PutScreen.routeName: (context) => const PutScreen(),
      ControlDoorScreen.routeName: (context) => const ControlDoorScreen(),
      PointScreen.routeName: (context) => const PointScreen(),
    };

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes : routes,
      home: const HomeScreen(),
    );
  }
}