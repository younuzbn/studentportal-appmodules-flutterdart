import 'dart:convert';
import 'package:http/http.dart'as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SendIdCardRequest(title: 'Students Portal'),
    );
  }
}

class SendIdCardRequest extends StatefulWidget {
  const SendIdCardRequest({super.key, required this.title});


  final String title;

  @override
  State<SendIdCardRequest> createState() => _SendIdCardRequestState();
}

class _SendIdCardRequestState extends State<SendIdCardRequest> {
  TextEditingController department=new TextEditingController();
  TextEditingController academicyear=new TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             TextFormField(
               controller: department,
               decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Department')),
             ),
              SizedBox(height: 15,),
              TextFormField(
                controller: academicyear,
                decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Academic Year')),
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Photo')),
              ),
              SizedBox(height: 15,),
              ElevatedButton(onPressed: (){_send_data();}, child: Text('Send Id Card Request'))
            ],
          ),
        ),
      ),

    );
  }
  void _send_data() async{



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/user_loginpost/');
    try {
      final response = await http.post(urls, body: {
        'department':department.text,
        'academicyear':academicyear.text,
        'photo':"",
        'lid':lid,


      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {


          Navigator.push(context, MaterialPageRoute(
            builder: (context) => MyLoginPage(title: "Home"),));
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
