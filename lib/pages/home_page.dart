import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:studentsportal/pages/daily_page.dart';
import 'package:studentsportal/pages/transection_page.dart';
import 'package:studentsportal/send%20complaint.dart';
import 'package:studentsportal/theme/colors.dart';
import 'package:studentsportal/view%20club%20request%20status.dart';

import '../cmchat.dart';
import '../view club.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  
List<Widget> pages = [
    DailyPage(),
    ChatPage(),
    ViewClub(title:'', ),
    ViewClubRequestStatus(title: '',),
    // ViewClubRequestStatus(title: '',),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: primary,
      body: getBody(),
      bottomNavigationBar: getFooter(),
      // floatingActionButton: SafeArea(
      //   child: SizedBox(
      //     // height: 30,
      //     // width: 40,
      //     child: FloatingActionButton(
      //       onPressed: () {},
      //       child: Icon(
      //         Icons.add,
      //         size: 20,
      //       ),
      //       backgroundColor: buttoncolor,
      //       // shape:
      //       //     BeveledRectangleBorder(borderRadius: BorderRadius.circular(4)),
      //     ),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
     return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      CupertinoIcons.home,
      CupertinoIcons.text_insert,
      CupertinoIcons.flag_fill,
      CupertinoIcons.flag_circle,
    ];
    return AnimatedBottomNavigationBar(
       backgroundColor: primary,
       icons: iconItems,
        splashColor: secondary,
        inactiveColor: black.withOpacity(0.5),
        gapLocation: GapLocation.center,
        activeIndex: pageIndex,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        iconSize: 25,
        rightCornerRadius: 10,
        elevation: 2,
        onTap: (index) {
          setTabs(index);
        });
  }

  setTabs(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
