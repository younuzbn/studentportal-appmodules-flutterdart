import 'package:flutter/material.dart';

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

              },
              title: Text("View profile"),
              leading: Icon(Icons.person),
            ),
              ListTile(
              onTap: (){

              },
              title: Text("Send Bus Pass Request"),
              leading: Icon(Icons.bus_alert),
            ),
              ListTile(
              onTap: (){

              },
              title: Text("Send Id Card Request"),
              leading: Icon(Icons.badge),
            ),
              ListTile(
              onTap: (){

              },
              title: Text("Join Club"),
              leading: Icon(Icons.house_siding_outlined),
            ),
              ListTile(
              onTap: (){

              },
              title: Text("Membership Status"),
              leading: Icon(Icons.approval_rounded),
            ),
              ListTile(
              onTap: (){

              },
              title: Text("View Attendance"),
              leading: Icon(Icons.list),
            ),
              ListTile(
              onTap: (){

              },
              title: Text("Send Complaint"),
              leading: Icon(Icons.note),
            ),
              ListTile(
              onTap: (){

              },
              title: Text("View Reply"),
              leading: Icon(Icons.reply),
            ),
              ListTile(
              onTap: (){

              },
              title: Text("Change Password"),
              leading: Icon(Icons.password),
            ),
              ListTile(
              onTap: (){

              },
              title: Text("Logout"),
              leading: Icon(Icons.logout),
            ),

          ],
        ),
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
              ElevatedButton(onPressed: (){}, child: Text('connect'))
            ],
          ),
        ),
      ),

    );
  }
}
