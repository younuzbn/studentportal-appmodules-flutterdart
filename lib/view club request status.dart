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
      home: const ViewClubRequestStatus(title: 'Students Portal'),
    );
  }
}

class ViewClubRequestStatus extends StatefulWidget {
  const ViewClubRequestStatus({super.key, required this.title});


  final String title;

  @override
  State<ViewClubRequestStatus> createState() => _ViewClubRequestStatusState();
}

class _ViewClubRequestStatusState extends State<ViewClubRequestStatus> {
  _ViewClubRequestStatusState(){
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
                                  child: Text(CLUB_[index]),
                                ),    Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(date_[index]),
                                ),  Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(Status_[index]),
                                ),
                              ],
                            ),

                          ]
                      ),

                      elevation: 8,
                      margin: EdgeInsets.all(10),
                    ),
                  ],
                )),
          );
        },
      ),

    );
  }
  List<String> id_=<String>[];
  List<String> CLUB_=<String>[];
  List<String> date_=<String>[];
  List<String> Status_=<String>[];

  Future<void> viewreply() async {
    List<String> id=<String>[];
    List<String> CLUB=<String>[];
    List<String> date=<String>[];
    List<String> Status=<String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/view_club_request_status/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date']);
        CLUB.add(arr[i]['club']);
        Status.add(arr[i]['stat']);
      }

      setState(() {
        id_ = id;
        date_ = date;
        CLUB_ = CLUB;
        date_ = date;
        Status_ = Status;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }
}
