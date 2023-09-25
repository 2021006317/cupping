import 'package:esp8266_with_firebase/screens/home_screen.dart';
import 'package:esp8266_with_firebase/screens/point_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ControlDoorScreen extends StatefulWidget {
  const ControlDoorScreen({super.key});

  static const routeName = '/control_door_screen';

  @override
  State<ControlDoorScreen> createState() => _ControlDoorScreenState();
}

enum Char { Y, N }
class _ControlDoorScreenState extends State<ControlDoorScreen> {
  Future<void> updateMovement(String movement) async {
    DatabaseReference weightRef = FirebaseDatabase.instance.ref("movement");
    await weightRef.update({
      "move" : movement
    });
  }

  void routing(){
    Navigator.pushNamed(
        context,
        PointScreen.routeName
    );
  }

  @override
  Widget build(BuildContext context) {
    Char _char = Char.N;
    final args = ModalRoute.of(context)!.settings.arguments as String;
    updateMovement(args);
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref("movement").onChildChanged,
      builder: (context, AsyncSnapshot<DatabaseEvent> eventSnapshot){
        if (eventSnapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }
        List<Widget> children;
        if(eventSnapshot.hasData){
          String? key = eventSnapshot.data!.snapshot.key;
          String movement = eventSnapshot.data!.snapshot.value as String; // close 여야 함.
          if (key != "move"){
            children = [Text('Error: ${eventSnapshot.error}')];
          }
          else {
            if(movement=="close"){
              updateMovement(movement);
              children = <Widget>[
                const Text("회수가 완료되었습니다. 적립하시겠습니까?"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: (){
                      routing();
                    }, child: Text("Y")),
                    TextButton(onPressed: (){
                      routing();
                    }, child: Text("N")),
                  ],
                )
              ];
            } else if (movement=="open"){
              children = [const CircularProgressIndicator()];
            } else {
              children = [Text('Error: ${eventSnapshot.error}')];
            }
          }
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
          children = [SizedBox()];
        }
        return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            )
        );
      },
    );
  }
}