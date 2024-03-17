import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:studentsportal/pages/home_page.dart';
import 'package:studentsportal/styles/app_colors.dart';
void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat',
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  _ChatPageState(){
    getdata();
  }
  final TextEditingController complaint = TextEditingController();
  final List<String> _messages = [];
  final formkey = GlobalKey<FormState>();
  final ScrollController _controller = ScrollController();



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => HomePage(),));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.my_white,
          actions: [
            IconButton(onPressed: (){
              _scrollToBottom();
            }, icon: Icon(Icons.arrow_downward))
          ],
          title: Text("Complaint"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child:

              Container(
                color: Colors.white,
                child: ListView.builder(
                  controller: _controller,
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
                                                SizedBox(height: 12),
                                                Text(
                                                  complaint_[index],
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  reply_[index],
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
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Form(
                      key: formkey,
                      child: Expanded(
                        child: TextFormField(
                          validator: (value){
                            String t = value!.trim();
                            if (t.isEmpty){
                              return "Please Fill Your Complaint";
                            }
                            return null;
                          },
                          controller: complaint,
                          decoration: InputDecoration(
                            hintText: 'Type your Complaint...',
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                      if (formkey.currentState!.validate()){
                        _send_data();}
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  List<String> id_=<String>[];
  List<String> date_=<String>[];
  List<String> reply_=<String>[];
  List<String> status_=<String>[];
  List<String> complaint_=<String>[];

  Future<void> getdata() async {
    List<String> id = <String>[];
    List<String> date = <String>[];
    List<String> complaint = <String>[];
    List<String> reply = <String>[];
    List<String> status = <String>[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/view_complaint_reply/';

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
        complaint.add(arr[i]['complaint'].toString());
        reply.add(arr[i]['reply'].toString());
        status.add(arr[i]['status'].toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        complaint_ = complaint;
        reply_ = reply;
        status_ = status;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
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
          getdata();
          setState(() {
            complaint.text='';
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
  void _scrollToBottom() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
