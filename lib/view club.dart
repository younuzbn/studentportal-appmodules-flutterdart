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
      home: const ViewClub(title: 'Students Portal'),
    );
  }
}

class ViewClub extends StatefulWidget {
  const ViewClub({super.key, required this.title});


  final String title;

  @override
  State<ViewClub> createState() => _ViewClubState();
}

class _ViewClubState extends State<ViewClub> {
  _ViewClubState(){
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
                                  child: Text(name_[index]),
                                ),    Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(logo_[index]),
                                ),  Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(description_[index]),
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
  List<String> name_=<String>[];
  List<String> logo_=<String>[];
  List<String> description_=<String>[];

  Future<void> viewreply() async {
    List<String> id=<String>[];
    List<String> name=<String>[];
    List<String> logo=<String>[];
    List<String> description=<String>[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/join_club/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        name.add(arr[i]['date']);
        logo.add(arr[i]['complaint']);
        description.add(arr[i]['reply']);
      }

      setState(() {
        id_ = id;
        name_ = name;
        logo_ = logo;
        description_ = description;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }
}
