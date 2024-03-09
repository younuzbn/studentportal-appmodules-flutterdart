import 'package:flutter/material.dart';
import 'package:studentsportal/styles/app_colors.dart';
// import 'package:studentsportal/screens/signup.dart';
import 'package:studentsportal/widgets/custom_button.dart';
import 'package:studentsportal/widgets/custom_formfield.dart';
import 'package:studentsportal/widgets/custom_header.dart';
import 'package:studentsportal/widgets/custom_richtext.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: AppColors.blue,
              ),
              CustomHeader(
                text: 'Students Portal',
                onTap: () {
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => const SignUp()));
                },
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.24,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: AppColors.whiteshade,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.09),
                        child: Image.asset("assets/images/login.png"),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      CustomFormField(
                        headingText: "Register Number",
                        hintText: "Enter Your Register Number",
                        obsecureText: false,
                        suffixIcon: const SizedBox(),
                        controller: _emailController,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        headingText: "Password",
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        hintText: "Enter Your Password",
                        obsecureText: true,
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.visibility), onPressed: () {}),
                        controller: _passwordController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: AppColors.blue.withOpacity(0.7),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AuthButton(
                        onTap: () {
                          _send_data();

                        },
                        text: 'Sign In',
                      ),
                      // CustomRichText(
                      //   discription: "Don't already Have an account? ",
                      //   text: "Sign Up",
                      //   onTap: () {
                      //     // Navigator.pushReplacement(
                      //     //     context,
                      //     //     MaterialPageRoute(
                      //     //         builder: (context) => const SignUp()));
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
  void _send_data() async{



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/login_student/');
    try {
      final response = await http.post(urls, body: {
        'username':_emailController.text,
        'password':_passwordController.text,


      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {

          String lid=jsonDecode(response.body)['lid'].toString();
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
