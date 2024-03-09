import 'dart:convert';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentsportal/login.dart';
import 'package:studentsportal/pages/daily_page.dart';
import 'package:studentsportal/send%20complaint.dart';
import 'package:studentsportal/styles/app_colors.dart';
import 'package:studentsportal/theme/colors.dart';
import 'package:studentsportal/view%20club%20request%20status.dart';
import 'package:studentsportal/view%20club.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChangePassword(title: 'Students Portal'),
    );
  }
}

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, required this.title});


  final String title;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  int pageIndex = 1;


  List<Widget> pages = [
    DailyPage(),
    SendComplaint(title: '',),
    ViewClub(title:'', ),
    ViewClubRequestStatus(title: '',),
    // ViewClubRequestStatus(title: '',),
  ];
  TextEditingController currentcontroller=new TextEditingController();
  TextEditingController newcontroller=new TextEditingController();
  TextEditingController confirmcontroller=new TextEditingController();



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.my_white,
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
          decoration: BoxDecoration(color: AppColors.my_white),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 TextFormField(
                   controller: currentcontroller,
                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Current Password')),
                 ),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: newcontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(),label: Text('New Password')),
                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: confirmcontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Confirm Password')),
                  ),
                  SizedBox(height: 15,),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white), // Set button color to white
                        side: MaterialStateProperty.all(BorderSide(color: Colors.black)), // Set border color to black
                      ),
                      onPressed: (){_send_data();}, child: Text(
                      'Send Complaint',
                      style: TextStyle(color: Colors.black)))
                ],
              ),
            ),
          ),
        ),
        // bottomNavigationBar: getFooter(),

      ),
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
  void _send_data() async{



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/change_password_student/');
    try {
      final response = await http.post(urls, body: {
        'current_password':currentcontroller.text,
        'new_password':newcontroller.text,
        'confirm_password':confirmcontroller.text,
        'lid':lid,


      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {


          Navigator.push(context, MaterialPageRoute(
            builder: (context) => MyLoginPage(title: "Home"),));
        }else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e){
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
