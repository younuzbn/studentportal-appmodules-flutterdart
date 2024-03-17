import 'dart:convert';
import 'package:http/http.dart'as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentsportal/home.dart';
import 'package:studentsportal/pages/home_page.dart';
import 'package:studentsportal/styles/app_colors.dart';

import 'login.dart';

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

        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const SendComplaint(title: 'Students Portal'),
    );
  }
}

class SendComplaint extends StatefulWidget {
  const SendComplaint({super.key, required this.title});


  final String title;

  @override
  State<SendComplaint> createState() => _SendComplaintState();
}

class _SendComplaintState extends State<SendComplaint> {
  TextEditingController complaint=new TextEditingController();
  final formkey = GlobalKey<FormState>();


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
            IconButton(onPressed: (){

            }, icon: Icon(Icons.message))
          ],
          leading: BackButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
            },
          ),

          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,

          title: Text(widget.title),
        ),
        body: Container(
          decoration: BoxDecoration(color: AppColors.my_white),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   TextFormField(
                     validator: (value){
                       // String t = value!.trim();
                       if (value!.isEmpty){
                         return "Please Fill Your Complaint";
                       }
                       return null;
                     },
                     controller: complaint,
                     decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Enter Your Complaint')),
                   ),
                    SizedBox(height: 15,),
                    ElevatedButton(onPressed: (){
                    if (formkey.currentState!.validate()){
                      _send_data();}},style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white), // Set button color to white
                      side: MaterialStateProperty.all(BorderSide(color: Colors.black)), // Set border color to black
                    ), child: Text(
                        'Send Complaint',
                        style: TextStyle(color: Colors.black)))
                  ],
                ),
              ),
            ),
          ),
        ),

      ),
    );
  }
  void _send_data() async{



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/send_complaint/');
    try {
      final response = await http.post(urls, body: {
        'complaint':complaint.text,
        'lid':lid,


      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          Fluttertoast.showToast(msg: 'Complaint Sent Successfully');

          Navigator.push(context, MaterialPageRoute(
            builder: (context) => HomePage(),));
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
