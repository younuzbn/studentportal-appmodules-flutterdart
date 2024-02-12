import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentsportal/login.dart';

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
      home: const ChangePassword(title: 'Students Portal'),
    );
  }
}

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, required this.title});


  final String title;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentcontroller=new TextEditingController();
  TextEditingController newcontroller=new TextEditingController();
  TextEditingController confirmcontroller=new TextEditingController();



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
               controller: currentcontroller,
               decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Current Password')),
             ),
              SizedBox(height: 15,),
              TextFormField(
                controller: newcontroller,
                decoration: InputDecoration(border: OutlineInputBorder(),label: Text('New Password')),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: confirmcontroller,
                decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Confirm Password')),
              ),
              SizedBox(height: 15,),
              ElevatedButton(onPressed: (){_send_data();}, child: Text('Change Password'))
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

    final urls = Uri.parse('$url/change_password_student/');
    try {
      final response = await http.post(urls, body: {
        'current':currentcontroller.text,
        'new':newcontroller.text,
        'confirm':confirmcontroller.text,
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
