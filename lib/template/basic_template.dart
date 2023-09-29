/* 상단바. AppBar */
import 'package:flutter/material.dart';

class TopPositionedBar extends StatefulWidget implements PreferredSizeWidget{
  final AppBar appBar;
  String? subTitle;
  TopPositionedBar ({Key? key, required this.appBar, String? subTitle = '한양대학교'}):this.subTitle = subTitle, super(key:key);

  @override
  State<TopPositionedBar> createState() => _TopPositionedBarState();

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class _TopPositionedBarState extends State<TopPositionedBar> {
  @override
  Widget build(BuildContext context){

    PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
            children: [
              Icon(item.icon, color: Colors.black, size: 30),
              const SizedBox(width: 8),
              Text(item.text)
            ]
        )
    );

    return AppBar(
      backgroundColor: Colors.purple,
      title: Text("cupping"),
      actions: [

      ],
    )
    // return AppBar(
    //   backgroundColor: Colors.purple,
    //   elevation: context.watch<GlobalVariable>().searchVisibility ? 10 : 0,
    //   title: Text('한양대학교', style: TextStyle(color: Colors.white, fontSize: 30)),
    //   // automaticallyImplyLeading: false,
    //   actions: [
    //     IconButton(onPressed: (){ context.read<GlobalVariable>().notFunc(); }, icon: Icon(Icons.search, size: 30,), tooltip: 'search'),
    //     PopupMenuButton(
    //         onSelected: (item) => onSelected(context, item),
    //         itemBuilder: (context) {
    //           return MenuItemElements.items.map(buildItem).toList();
    //         }
    //     )
    //   ],
    // );
  }
}

/* 상단바 우측의 메뉴버튼 */
class MenuItem {
  final IconData icon;
  final String text;

  const MenuItem({required this.icon, required this.text});
}

class MenuItemElements {
  static const MyPage = MenuItem(
      icon: Icons.person,
      text: '마이페이지'
  );
  static const Settings = MenuItem(
      icon: Icons.settings,
      text: '환경설정'
  );
  static const List<MenuItem> items = [MyPage, Settings];
}

void onSelected(BuildContext context, MenuItem item){
  switch(item){
    case MenuItemElements.MyPage:
      Navigator.of(context).pushNamed(MyPageScreen.routeName);
      break;
    case MenuItemElements.Settings:
      Navigator.of(context).pushNamed(SettingScreen.routeName);
      break;
  }
}