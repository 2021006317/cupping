import 'package:esp8266_with_firebase/screens/plzThrowIntoTrashcan.dart';
import 'package:esp8266_with_firebase/screens/end_screen.dart';
import 'package:esp8266_with_firebase/screens/inputPhoneNumberScreen.dart';
import 'package:esp8266_with_firebase/screens/EndOfGetStampThanks.dart';
import 'package:esp8266_with_firebase/screens/SelectCup.dart';
import 'package:esp8266_with_firebase/screens/PutAfterWashValidOrInvalid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'screens/HomeScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  _initialize();
  runApp(const MyApp());
}

/* 비동기 처리 해야 하는 것들 */
Future<void> _initialize() async {
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final routes = {
      HomeScreen.routeName: (context) => const HomeScreen(),
      PutAfterWashValidOrInvalid.routeName: (context) => const PutAfterWashValidOrInvalid(),
      SelectCup.routeName: (context) => const SelectCup(),
      plzThrowIntoTrashCan.routeName: (context) => const plzThrowIntoTrashCan(),
      inputPhoneNumberScreen.routeName: (context) => const inputPhoneNumberScreen(),
      EndOfGetStampThanks.routeName: (context) => const EndOfGetStampThanks(),
      EndScreen.routeName: (context) => const EndScreen()
    };

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'YeongdeokSea',
        useMaterial3: true,
      ),
      routes : routes,
      home: const HomeScreen(),
    );
  }
}