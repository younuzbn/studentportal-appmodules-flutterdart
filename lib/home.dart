import 'package:flutter/material.dart';
import 'package:studentsportal/send%20bus%20pass%20request.dart';
import 'package:studentsportal/send%20complaint.dart';
import 'package:studentsportal/send%20id%20card%20request.dart';
import 'package:studentsportal/view%20attendance.dart';
import 'package:studentsportal/view%20club%20request%20status.dart';
import 'package:studentsportal/view%20club.dart';
import 'package:studentsportal/view%20profile.dart';
import 'package:studentsportal/view%20reply.dart';

import 'change password.dart';
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
      home: const pagenew(title: 'Students Portal'),
    );
  }
}

class pagenew extends StatefulWidget {
  const pagenew({super.key, required this.title});


  final String title;

  @override
  State<pagenew> createState() => _pagenewState();
}

class _pagenewState extends State<pagenew> {
  TextEditingController ipaddress=new TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child:Column(
              children: [
                CircleAvatar(),
                Text("Muhammed Younuz"),
                Text("Regsiter Number")
              ],
            )),
            ListTile(
              onTap: (){

              },
              title: Text("Home"),
              leading: Icon(Icons.home),
            ),
             ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewProfile(title: 'profile',)));

              },
              title: Text("View profile"),
              leading: Icon(Icons.person),
            ),
              ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SendBusPassRequest(title: 'Send Bus Pass Request',)));

              },
              title: Text("Send Bus Pass Request"),
              leading: Icon(Icons.bus_alert),
            ),
              ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SendIdCardRequest(title: 'Send Id Card Request',)));

              },
              title: Text("Send Id Card Request"),
              leading: Icon(Icons.badge),
            ),
              ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewClub(title: 'Join Club',)));

              },
              title: Text("Join Club"),
              leading: Icon(Icons.house_siding_outlined),
            ),
              ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewClubRequestStatus(title: 'View Club Request Status',)));

              },
              title: Text("Membership Status"),
              leading: Icon(Icons.approval_rounded),
            ),
              ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAttendance(title: 'View Attendance',)));

              },
              title: Text("View Attendance"),
              leading: Icon(Icons.list),
            ),
              ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SendComplaint(title: 'Send Complaint',)));

              },
              title: Text("Send Complaint"),
              leading: Icon(Icons.note),
            ),
              ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewReply(title: 'View Reply',)));

              },
              title: Text("View Reply"),
              leading: Icon(Icons.reply),
            ),
              ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePassword(title: 'Change Password',)));

              },
              title: Text("Change Password"),
              leading: Icon(Icons.password),
            ),
              ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLoginPage(title: 'MyLoginPage',)));


              },
              title: Text("Logout"),
              leading: Icon(Icons.logout),
            ),

          ],
        ),
      ),
      body: Text("")

    );
  }
}
