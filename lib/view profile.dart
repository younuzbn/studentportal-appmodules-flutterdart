import 'dart:convert';
import 'package:http/http.dart'as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      home: const ViewProfile(title: 'Students Portal'),
    );
  }
}

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key, required this.title});


  final String title;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  _ViewProfileState(){
    _send_data();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Text(name_),
          CircleAvatar(
            backgroundImage: NetworkImage(photo_),
          ),
          Text(house_name_),
          Text(street_),
          Text(pin_),
          Text(post_),
          Text(register_number_),
          Text(date_of_birth_),
          Text(phone_no_),
          Text(email_id_)
        ],
      )

    );
  }
  String name_="";
  String photo_="";
  String house_name_="";
  String street_="";
  String pin_="";
  String post_="";
  String register_number_="";
  String date_of_birth_="";
  String phone_no_="";
  String email_id_="";

  void _send_data() async{



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String imageurl = sh.getString('imageurl').toString();

    final urls = Uri.parse('$url/view_profile_student/');
    try {
      final response = await http.post(urls, body: {
        'lid':lid



      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          String name=jsonDecode(response.body)['name'];
          String photo=imageurl+jsonDecode(response.body)['photo'];
          String house_name=jsonDecode(response.body)['house_name'];
          String street=jsonDecode(response.body)['street'];
          String pin=jsonDecode(response.body)['pin'];
          String post=jsonDecode(response.body)['post'];
          String register_number=jsonDecode(response.body)['register_number'];
          String date_of_birth=jsonDecode(response.body)['date_of_birth'];
          String phone_no=jsonDecode(response.body)['phone_number'];
          String email_id=jsonDecode(response.body)['email_id'];

          setState(() {

            name_= name;
            photo_= photo;
            house_name_= house_name;
            street_= street;
            pin_= pin;
            post_= post;
            register_number_= register_number;
            date_of_birth_= date_of_birth;
            phone_no_= phone_no;
            email_id_= email_id;
          });





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
