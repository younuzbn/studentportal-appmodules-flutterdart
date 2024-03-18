import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentsportal/styles/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ViewNotification(title: 'Students Portal'),
    );
  }
}

class ViewNotification extends StatefulWidget {
  const ViewNotification({Key? key, required this.title});

  final String title;

  @override
  State<ViewNotification> createState() => _ViewNotificationState();
}

class _ViewNotificationState extends State<ViewNotification> {
  List<String> id_ = <String>[];
  List<String> date_ = <String>[];
  List<String> notification_ = <String>[];
  List<String> hiddenNotifications = [];

  @override
  void initState() {
    super.initState();
    getdata();
    getHiddenNotifications();
  }

  void getHiddenNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hiddenNotifications = prefs.getStringList('hiddenNotifications') ?? [];
    });
  }

  void setHiddenNotifications(List<String> notifications) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('hiddenNotifications', notifications);
  }

  Future<void> toggleHideNotification(String id) async {
    if (hiddenNotifications.contains(id)) {
      hiddenNotifications.remove(id);
    } else {
      hiddenNotifications.add(id);
    }
    setHiddenNotifications(hiddenNotifications);
    setState(() {});
  }

  Future<void> getdata() async {
    List<String> id = <String>[];
    List<String> date = <String>[];
    List<String> notification = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/view_notification/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata['data'];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date'].toString());
        notification.add(arr[i]['notification'].toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        notification_ = notification;
      });

      print(statuss);
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.my_white,
          title: Text("Notification"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  hiddenNotifications.clear();
                  setHiddenNotifications([]);
                });
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: id_.length,
            itemBuilder: (BuildContext context, int index) {
              final String id = id_[index];
              final bool isHidden = hiddenNotifications.contains(id);
              if (isHidden) {
                return SizedBox.shrink(); // Hide the notification
              }
              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      date_[index],
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        toggleHideNotification(id);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  notification_[index],
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
