import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
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

    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.my_white,
          actions: [
            IconButton(
              onPressed: () async {
                // Set an initial date
                DateTime initialDate = DateTime.now();

                // Open a date picker with the initial date
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),

                );

                // Handle the selected date as needed
                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  print('Selected Date: ${formattedDate}');
                  final sh =await SharedPreferences.getInstance();
                  sh.setString("date", formattedDate);
                  viewreply2();
                  Fluttertoast.showToast(msg: '${formattedDate}');
                  // You can perform actions with the selected date here
                }
              },
              splashRadius: 1.0,
              icon: Icon(
                Icons.calendar_month,
                color: Colors.black,
                size: 34.0,
              ),
            ),
          ],

          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,

          title: Text("Attendance"),
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
                                height: 180, // Set the desired height of the card
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
                                          SizedBox(height: 12),Text(
                                            subject_[index],
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 12),Text(
                                            hour_[index],
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            status_[index],
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
  List<String> subject_=<String>[];
  List<String> date_=<String>[];
  List<String> hour_=<String>[];
  List<String> status_=<String>[];

  Future<void> viewreply() async {
    List<String> id=<String>[];
    List<String> subject=<String>[];
    List<String> date=<String>[];
    List<String> hour=<String>[];
    List<String> status=<String>[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/view_attendance/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        subject.add(arr[i]['subject']);
        date.add(arr[i]['date']);
        hour.add(arr[i]['hour']);
        status.add(arr[i]['status']);
      }

      setState(() {
        id_ = id;
        subject_ = subject;
        date_ = date;
        hour_ = hour;
        status_ = status;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }
  Future<void> viewreply2() async {
    List<String> id=<String>[];
    List<String> subject=<String>[];
    List<String> date=<String>[];
    List<String> hour=<String>[];
    List<String> status=<String>[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String date1 = sh.getString('date').toString();
      String url = '$urls/view_attendancesea/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid,
        'date':date1,

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        subject.add(arr[i]['subject']);
        date.add(arr[i]['date']);
        hour.add(arr[i]['hour']);
        status.add(arr[i]['status']);
      }

      setState(() {
        id_ = id;
        subject_ = subject;
        date_ = date;
        hour_ = hour;
        status_ = status;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }
}
