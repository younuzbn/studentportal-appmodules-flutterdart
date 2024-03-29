import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentsportal/login.dart';
import 'package:studentsportal/pages/login_page.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'logintemp.dart';

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
                 // fontFamily: GoogleFonts.poppins().fontFamily,

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Students Portal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController ipaddress=new TextEditingController();


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
               controller: ipaddress,
               decoration: InputDecoration(border: OutlineInputBorder(),label: Text('ip address')),
             ),
              SizedBox(height: 15,),
              ElevatedButton(onPressed: () async {
                SharedPreferences sh = await SharedPreferences.getInstance();
                sh.setString("url", "http://"+ipaddress.text+":8000/myapp").toString();
                sh.setString("imageurl", "http://"+ipaddress.text+":8000").toString();

                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => LoginPage(),));
                Fluttertoast.showToast(msg: 'ip connected successfully');

              }, child: Text('connect'))
            ],
          ),
        ),
      ),

    );
  }
}
