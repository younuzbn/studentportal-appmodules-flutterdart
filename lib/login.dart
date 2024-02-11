import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyLoginPage(title: 'Students Portal'),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});


  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
TextEditingController username=new TextEditingController();
TextEditingController password=new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           TextFormField(
             controller: username,
             decoration: InputDecoration(border: OutlineInputBorder(),label: Text('User Name')),
           ),
            SizedBox(height: 15,),
            TextFormField(
              controller: password,
              decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Password')),
            ),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: (){_send_data();}, child: Text('Login'))
          ],
        ),
      ),

    );
  }
void _send_data() async{



  SharedPreferences sh = await SharedPreferences.getInstance();
  String url = sh.getString('url').toString();

  final urls = Uri.parse('$url/user_loginpost/');
  try {
    final response = await http.post(urls, body: {
      'username':username.text,
      'password':password.text,


    });
    if (response.statusCode == 200) {
      String status = jsonDecode(response.body)['status'];
      if (status=='ok') {

        String lid=jsonDecode(response.body)['lid'];
        sh.setString("lid", lid);

        Navigator.push(context, MaterialPageRoute(
          builder: (context) => pagenew(title: "Home"),));
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
