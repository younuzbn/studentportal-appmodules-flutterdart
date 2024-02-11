import 'dart:convert';
import 'package:http/http.dart'as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: const ViewAttendance(title: 'Students Portal'),
    );
  }
}

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({super.key, required this.title});


  final String title;

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  _ViewAttendanceState(){
    viewreply();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body:  ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: id_.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      child:
                      Row(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(date_[index]),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(subject_[index]),
                                ),    Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(day_[index]),
                                ),
                              ],
                            ),

                          ]
                      ),

                      elevation: 8,
                    ),
                  ],
                )),
          );
        },
      ),

    );
  }
  List<String> id_=<String>[];
  List<String> subject_=<String>[];
  List<String> date_=<String>[];
  List<String> day_=<String>[];

  Future<void> viewreply() async {
    List<String> id=<String>[];
    List<String> subject=<String>[];
    List<String> date=<String>[];
    List<String> day=<String>[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/myapp/user_viewreply/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        subject.add(arr[i]['date']);
        date.add(arr[i]['complaint']);
        day.add(arr[i]['reply']);
      }

      setState(() {
        id_ = id;
        subject_ = subject;
        date_ = date;
        day_ = day;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }
}
