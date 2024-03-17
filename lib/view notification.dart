import 'dart:convert';
import 'package:http/http.dart'as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentsportal/styles/app_colors.dart';

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

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ViewNotification(title: 'Students Portal'),
    );
  }
}

class ViewNotification extends StatefulWidget {
  const ViewNotification({super.key, required this.title});


  final String title;

  @override
  State<ViewNotification> createState() => _ViewNotificationState();
}

class _ViewNotificationState extends State<ViewNotification> {
  _ViewNotificationState(){
    getdata();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: Scaffold(
        appBar: AppBar(

          backgroundColor: AppColors.my_white,

          title: Text("Notification"),
          centerTitle: true,
        ),
        body:  Container(
          color: Colors.white,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: id_.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black), // Add black border
                            borderRadius: BorderRadius.circular(10), // Set border radius
                          ),
                          child: Card(
                            elevation: 0,
                            color: Colors.white, // Set card color to white
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox( // Wrap the card with SizedBox
                                height: 100, // Set the desired height of the card
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(10), // Set border radius
                                    //   child: SizedBox(
                                    //     width: 90, // Set width of the image
                                    //     height: 90, // Set height of the image
                                    //     child: Image.network(
                                    //       logo_[index],
                                    //       fit: BoxFit.cover, // Adjust the image to cover the entire space
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            date_[index],
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                  ],
                                ),
                              ),
                            ),
                            margin: EdgeInsets.all(10),
                          ),
                        ),
                      ],
                    )),
              );
            },
          ),
        ),

      ),
    );
  }

  List<String> id_=<String>[];
  List<String> date_=<String>[];
  List<String> notification_=<String>[];

  Future<void> getdata() async {
    List<String> id = <String>[];
    List<String> date = <String>[];
    List<String> notification = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/view_notification/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

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
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }
}
