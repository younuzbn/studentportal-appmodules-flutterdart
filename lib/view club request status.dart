import 'dart:convert';
import 'package:http/http.dart'as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentsportal/pages/home_page.dart';

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

    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
            },
          ),

          backgroundColor:Colors.white,

          title: Text("My Club"),
        ),
        body:
        Container(
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
                                height: 180, // Set the desired height of the card
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10), // Set border radius
                                      child: SizedBox(
                                        width: 90, // Set width of the image
                                        height: 90, // Set height of the image
                                        child: Image.network(
                                          logo_[index],
                                          fit: BoxFit.cover, // Adjust the image to cover the entire space
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            CLUB_[index],
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            description_[index],
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Status:"),
                                              Text(Status_[index])
                                            ],
                                          )
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
  List<String> CLUB_=<String>[];
  List<String> logo_=<String>[];
  List<String> description_=<String>[];
  List<String> date_=<String>[];
  List<String> Status_=<String>[];

  Future<void> viewreply() async {
    List<String> id=<String>[];
    List<String> CLUB=<String>[];
    List<String> logo=<String>[];
    List<String> description=<String>[];
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
        date.add(arr[i]['date'].toString());
        logo.add(sh.getString("imageurl").toString()+arr[i]['logo'].toString());
        description.add(arr[i]['description'].toString());
        CLUB.add(arr[i]['CLUB'].toString());
        Status.add(arr[i]['status'].toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        logo_ = logo;
        description_ = description;
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
