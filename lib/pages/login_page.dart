import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:studentsportal/pages/home_page.dart';
import 'package:studentsportal/theme/colors.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email =
      TextEditingController(text: "MFAVSCS031");
  TextEditingController password = TextEditingController(text: "aassddff");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: getBody(),
    );
  }

  bool show = true;

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/images/mhes.png"),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: grey.withOpacity(0.03),
                        spreadRadius: 10,
                        blurRadius: 3,
                        // changes position of shadow
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 15, bottom: 5, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Register Number",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Color(0xff67727d)),
                      ),
                      TextField(
                        controller: _email,
                        cursorColor: black,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: black),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: black,
                            hintText: "Email",
                            border: InputBorder.none),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: grey.withOpacity(0.03),
                        spreadRadius: 10,
                        blurRadius: 3,
                        // changes position of shadow
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 15, bottom: 5, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Color(0xff67727d)),
                      ),
                      TextField(
                        obscureText: show,
                        controller: password,
                        cursorColor: black,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: black),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                            prefixIconColor: Colors.black,
                            suffixIcon: IconButton(onPressed: (){
                              setState(() {
                                if(show==true){
                                  show = false;
                                }else{
                                  show = true;
                                }
                              });
                            },icon: Icon(show==true?Icons.remove_red_eye_outlined:Icons.visibility_off)),
                            suffixIconColor: Colors.black,
                            hintText: "Password",
                            border: InputBorder.none),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _send_data();
              },
              child: Container(
                
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  
                    color:buttoncolor, borderRadius: BorderRadius.circular(25)),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 26.0, right: 26.0),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Signup",
              //       style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 15,
              //           fontWeight: FontWeight.w300),
              //     ),
              //     Text(
              //       "Forgot Password?",
              //       style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 15,
              //           fontWeight: FontWeight.w300),
              //     ),
              //   ],
              // ),
            )
          ],
        ),
      ),
    ));
  }
  void _send_data() async{




    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/login_student/');
    try {
      final response = await http.post(urls, body: {
        'username':_email.text,
        'password':password.text,


      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {

          String lid=jsonDecode(response.body)['lid'].toString();
          sh.setString("lid", lid);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
          // Navigator.push(context, MaterialPageRoute(
          //   builder: (context) => pagenew(title: "Home"),));
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
