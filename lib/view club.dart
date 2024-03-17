import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentsportal/pages/home_page.dart';
import 'styles/app_colors.dart';

import 'home.dart';

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
      // theme: ThemeData(
      //
      //   // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      //   useMaterial3: true,
      // ),
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



            title: Text("Join Club"),
            centerTitle: true,
          ),
          body: Container(
            color: Colors.white, // Set background color to light blue
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
                                height: 200, // Set the desired height of the card
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
                                            name_[index],
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            description_[index],
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: 10),


                                          ElevatedButton(
                                            onPressed: () async {
                                              SharedPreferences sh = await SharedPreferences.getInstance();
                                              String url = sh.getString('url').toString();
                                              String lid = sh.getString('lid').toString();
                                              String clb = id_[index].toString();
                                              final urls = Uri.parse('$url/join_club/');
                                              try {
                                                final response = await http.post(urls, body: {
                                                  'club': clb,
                                                  'lid': lid,
                                                });
                                                if (response.statusCode == 200) {
                                                  String status = jsonDecode(response.body)['status'];
                                                  if (status == 'ok') {
                                                    Fluttertoast.showToast(msg: 'Request Sent Successfully');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => HomePage()),
                                                    );
                                                  } else {
                                                    Fluttertoast.showToast(msg: 'Not Found');
                                                  }
                                                } else {
                                                  Fluttertoast.showToast(msg: 'Network Error');
                                                }
                                              } catch (e) {
                                                Fluttertoast.showToast(msg: e.toString());
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.white), // Set button color to white
                                              side: MaterialStateProperty.all(BorderSide(color: Colors.black)), // Set border color to black
                                            ),
                                            child: Text(
                                              'Join Club',
                                              style: TextStyle(color: Colors.black), // Set text color to black
                                            ),
                                          ),



                                          // ElevatedButton(
                                          //   onPressed: () async {
                                          //     SharedPreferences sh = await SharedPreferences.getInstance();
                                          //     String url = sh.getString('url').toString();
                                          //     String lid = sh.getString('lid').toString();
                                          //     String clb = id_[index].toString();
                                          //     final urls = Uri.parse('$url/join_club/');
                                          //     try {
                                          //       final response = await http.post(urls, body: {
                                          //         'club': clb,
                                          //         'lid': lid,
                                          //       });
                                          //       if (response.statusCode == 200) {
                                          //         String status = jsonDecode(response.body)['status'];
                                          //         if (status == 'ok') {
                                          //           Fluttertoast.showToast(msg: 'Request Sent Successfully');
                                          //           Navigator.push(
                                          //             context,
                                          //             MaterialPageRoute(builder: (context) => HomePage()),
                                          //           );
                                          //         } else {
                                          //           Fluttertoast.showToast(msg: 'Not Found');
                                          //         }
                                          //       } else {
                                          //         Fluttertoast.showToast(msg: 'Network Error');
                                          //       }
                                          //     } catch (e) {
                                          //       Fluttertoast.showToast(msg: e.toString());
                                          //     }
                                          //   },
                                          //   child: Text('Join Club'
                                          //   ),
                                          // ),
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
                    ),
                  ),
                );
              },
            ),
          ),


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
      String url = '$urls/view_club_student/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        name.add(arr[i]['name'].toString());
        logo.add(sh.getString("imageurl").toString()+arr[i]['logo'].toString());
        
        // Fluttertoast.showToast(msg: sh.getString("imageurl").toString()+arr[i]['logo'].toString());
        
        description.add(arr[i]['description'].toString());
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
