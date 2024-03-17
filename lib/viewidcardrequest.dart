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
      home: const ViewIDCardRequest(title: 'Students Portal'),
    );
  }
}

class ViewIDCardRequest extends StatefulWidget {
  const ViewIDCardRequest({super.key, required this.title});


  final String title;

  @override
  State<ViewIDCardRequest> createState() => _ViewIDCardRequestState();
}

class _ViewIDCardRequestState extends State<ViewIDCardRequest> {
  _ViewIDCardRequestState(){
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

          backgroundColor: Theme.of(context).colorScheme.inversePrimary,

          title: Text(widget.title),
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
                                height: 80, // Set the desired height of the card
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
                                          photo_[index],
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
                                            status_[index],
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Academic Year",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Text(
                                                academic_year_[index],
                                                style: TextStyle(fontSize: 14),
                                              ),

                                            ],
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

        // ListView.builder(
        //   physics: BouncingScrollPhysics(),
        //   itemCount: id_.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return ListTile(
        //       title: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Column(
        //             children: [
        //               Card(
        //                 child:
        //                 Row(
        //                     children: [
        //                       Column(
        //                         children: [
        //                           Padding(
        //                             padding: EdgeInsets.all(5),
        //                             child: Text(date_[index]),
        //                           ),
        //                           Padding(
        //                             padding: EdgeInsets.all(5),
        //                             child: Text(photo_[index]),
        //                           ),    Padding(
        //                             padding: EdgeInsets.all(5),
        //                             child: Text(status_[index]),
        //                           ),  Padding(
        //                             padding: EdgeInsets.all(5),
        //                             child: Text(academic_year_[index]),
        //                           ),
        //                         ],
        //                       ),
        //
        //                     ]
        //                 ),
        //
        //                 elevation: 8,
        //                 margin: EdgeInsets.all(10),
        //               ),
        //             ],
        //           )),
        //     );
        //   },
        // ),

      ),
    );
  }

  List<String> id_=<String>[];
  List<String> date_=<String>[];
  List<String> photo_=<String>[];
  List<String> status_=<String>[];
  List<String> academic_year_=<String>[];

  Future<void> getdata() async {
    List<String> id = <String>[];
    List<String> date = <String>[];
    List<String> photo = <String>[];
    List<String> academic_year = <String>[];
    List<String> status = <String>[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/view_id_card_request_student/';

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
        photo.add(sh.getString("imageurl").toString()+arr[i]['photo'].toString());
        academic_year.add(arr[i]['academic_year'].toString());
        status.add(arr[i]['status'].toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        photo_ = photo;
        academic_year_ = academic_year;
        status_ = status;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }
}
