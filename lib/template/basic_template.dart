import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget implements PreferredSizeWidget{
  final AppBar appBar;
  String? subTitle;
  ProgressBar({Key? key, required this.appBar, this.subTitle = 'cupping'}): super(key:key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.purple,
      title: const Text('cupping', style: TextStyle(color: Colors.white, fontSize: 30)),
    );
  }
}
