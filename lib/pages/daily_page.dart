import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:studentsportal/change%20password.dart';
import 'package:studentsportal/pages/login_page.dart';
import 'package:studentsportal/send%20id%20card%20request.dart';
import 'package:studentsportal/theme/colors.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:studentsportal/view%20notification.dart';
import 'package:workmanager/workmanager.dart';

import '../send bus pass request.dart';
import '../view attendance.dart';
import '../view reply.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(

    // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true);
// Periodic task registration
  Workmanager().registerPeriodicTask(
    "2",

    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: Duration(seconds: 15),
  );
  runApp(mydaily());
}

class mydaily extends StatelessWidget {
  const mydaily({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
void callbackDispatcher(String message) {
  print("hiii");

  // Workmanager().executeTask((task, inputData) {
  // initialise the plugin of flutterlocalnotifications.
  FlutterLocalNotificationsPlugin flip =
  new FlutterLocalNotificationsPlugin();

  // app_icon needs to be a added as a drawable
  // resource to the Android head project.
  var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  // var IOS = new IOSInitializationSettings();

  // initialise settings for both Android and iOS device.
  var settings = new InitializationSettings(android: android);
  flip.initialize(settings);
  _showNotificationWithDefaultSound(flip, message);
  // return Future.value(true);
  // });
}

Future _showNotificationWithDefaultSound(flip,String message) async {
// Show a notification after every 15 minute with the first
// appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.max, priority: Priority.high);

// initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics =
  new NotificationDetails(android: androidPlatformChannelSpecifics);
  await flip.show(
      0,
      'New Notification',
      message,
      platformChannelSpecifics,
      payload: 'Default_Sound');
}


class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {

  _DailyPageState(){
    Timer.periodic(Duration(seconds: 15), (timer) {
      getdata();
    });
    _send_data();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(

        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 10),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: grey.withOpacity(0.03),
                    spreadRadius: 10,
                    blurRadius: 3,
                    // changes position of shadow
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 25, right: 20, left: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: Icon(Icons.password), onPressed: ()=> Navigator.push(context,MaterialPageRoute(builder:(context)=> ChangePassword(title: ''))),),
                      IconButton(icon: Icon(Icons.logout), onPressed: ()=> Navigator.push(context,MaterialPageRoute(builder:(context)=> LoginPage())),),
                    ]
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    photo_),
                                    // "https://images.unsplash.com/photo-1531256456869-ce942a665e80?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTI4fHxwcm9maWxlfGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60"),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: (size.width - 40) * 0.6,
                        child: Column(
                          children: [
                            Text(
                              name_,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: mainFontColor),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              email_id_,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: black),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            register_number_,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Register Number",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w100,
                                color: black),
                          ),
                        ],
                      ),
                      Container(
                        width: 0.5,
                        height: 40,
                        color: black.withOpacity(0.3),
                      ),
                      Column(
                        children: [
                          Text(
                            date_of_birth_,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Date of Birth",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w100,
                                color: black),
                          ),
                        ],
                      ),
                      Container(
                        width: 0.5,
                        height: 40,
                        color: black.withOpacity(0.3),
                      ),
                      Column(
                        children: [
                          Text(
                            admission_year_,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Admission Year",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w100,
                                color: black),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                         Text("Services",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: mainFontColor,
                    )),
                    IconBadge(
        icon: Icon(Icons.notifications_none),
        itemColor: mainFontColor,
        hideZero: true,
        top: -1,
        onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewNotification(title: '',)));
        },
      ),
                      ],
                    )
                  ],
                ),
                // Text("Overview",
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20,
                //       color: mainFontColor,
                //     )),
                Text(date_,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: mainFontColor,
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SendIdCardRequest(title: '',)));
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 20,
                            left: 25,
                            right: 25,
                          ),
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: grey.withOpacity(0.03),
                                  spreadRadius: 10,
                                  blurRadius: 3,
                                  // changes position of shadow
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, right: 20, left: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: arrowbgColor,
                                    borderRadius: BorderRadius.circular(15),
                                    // shape: BoxShape.circle
                                  ),
                                  child: Center(
                                      child: Icon(Icons.contact_phone)),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Container(
                                    width: (size.width - 90) * 0.7,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Sent",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "ID Crad Request",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: black.withOpacity(0.5),
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ]),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: black),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SendBusPassRequest(title: '',)));
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 25,
                            right: 25,
                          ),
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: grey.withOpacity(0.03),
                                  spreadRadius: 10,
                                  blurRadius: 3,
                                  // changes position of shadow
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, right: 20, left: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: arrowbgColor,
                                    borderRadius: BorderRadius.circular(15),
                                    // shape: BoxShape.circle
                                  ),
                                  child: Center(
                                      child: Icon(Icons.directions_bus_filled )),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Container(
                                    width: (size.width - 90) * 0.7,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Sent",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Bus Pass Request",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: black.withOpacity(0.5),
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ]),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: black),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAttendance(title: '',)));
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 25,
                            right: 25,
                          ),
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: grey.withOpacity(0.03),
                                  spreadRadius: 10,
                                  blurRadius: 3,
                                  // changes position of shadow
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, right: 20, left: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: arrowbgColor,
                                    borderRadius: BorderRadius.circular(15),
                                    // shape: BoxShape.circle
                                  ),
                                  child: Center(
                                      child: Icon(CupertinoIcons.checkmark_alt)),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Container(
                                    width: (size.width - 90) * 0.7,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Attendance",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Track Attendance Details",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: black.withOpacity(0.5),
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ]),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: black),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  String Reminer = "", id = "", Date = "", Time = "";

  Future<void> getdata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    try {
      // String url = "${sh.getString("url").toString()}/viewNotification/";


      String url = sh.getString('url').toString();

      final urls = Uri.parse('$url/view_push_notification/');

      String nid="0";
      if(sh.containsKey("nid")==false) {}
      else{
        nid=sh.getString('nid').toString();
      }
      Fluttertoast.showToast(msg:nid);

      var datas = await http
          .post(urls, body: {'nid': nid });
      var jsondata = json.decode(datas.body);
      String status = jsondata['status'];
      print(status);
      if (status == "ok") {
        String nid = jsondata['nid'].toString();
        String message = jsondata['message'];
        sh.setString('nid',nid);
        callbackDispatcher(message);
        // var data = json.decode(datas.body)['data'];
        // setState(() {
        //   for (int i = 0; i < data.length; i++) {
        //     Reminer = (data[i]['Reminder'].toString());
        //     id = (data[i]['id'].toString());
        //     Date = (data[i]['Date']);
        //     Time = (data[i]['Time']);
        //   }
        // });

      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }



  String name_="";
  String photo_="";
  String register_number_="";
  String date_="";
  String email_id_="";
  String date_of_birth_="";
  String admission_year_="";

  void _send_data() async{



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String imageurl = sh.getString('imageurl').toString();

    final urls = Uri.parse('$url/view_profile_student/');
    try {
      final response = await http.post(urls, body: {
        'lid':lid



      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          String name=jsonDecode(response.body)['name'];
          String photo=imageurl+jsonDecode(response.body)['photo'];
          String register_number=jsonDecode(response.body)['register_number'];
          String email_id=jsonDecode(response.body)['email_id'];
          String date=jsonDecode(response.body)['date'].toString();
          String admission_year=jsonDecode(response.body)['admission_year'].toString();
          String date_of_birth=jsonDecode(response.body)['date_of_birth'].toString();
          setState(() {

            name_= name;
            photo_= photo;
            register_number_= register_number;
            date_= date;
            email_id_= email_id;
            admission_year_= admission_year;
            date_of_birth_= date_of_birth;
          });





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
