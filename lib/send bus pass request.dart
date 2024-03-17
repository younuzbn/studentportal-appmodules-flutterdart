import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentsportal/pages/home_page.dart';
import 'package:studentsportal/styles/app_colors.dart';
import 'package:studentsportal/viewbuspassrequest.dart';

import 'home.dart';
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
      home: const SendBusPassRequest(title: 'Students Portal'),
    );
  }
}

class SendBusPassRequest extends StatefulWidget {
  const SendBusPassRequest({super.key, required this.title});


  final String title;

  @override
  State<SendBusPassRequest> createState() => _SendBusPassRequestState();
}

class _SendBusPassRequestState extends State<SendBusPassRequest> {
  TextEditingController department=new TextEditingController();
  TextEditingController fromlocation=new TextEditingController();
  TextEditingController tolocation=new TextEditingController();
  TextEditingController academicyear=new TextEditingController();
  final formkey = GlobalKey<FormState>();


  _SendBusPassRequestState(){
    viewreply();
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ViewBusPassRequest(title: '',),));
            }, icon: Icon(Icons.inbox))
          ],
          backgroundColor: AppColors.my_white,

          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,

          title: Text("Bus Pass Request"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: AppColors.my_white),
            child: Center(

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (_selectedImage != null) ...{
                        InkWell(
                          child:
                          Image.file(_selectedImage!, height: 400,),
                          radius: 399,
                          onTap: _checkPermissionAndChooseImage,
                          // borderRadius: BorderRadius.all(Radius.circular(200)),
                        ),
                      } else ...{
                        // Image(image: NetworkImage(),height: 100, width: 70,fit: BoxFit.cover,),
                        InkWell(
                          onTap: _checkPermissionAndChooseImage,
                          child:Column(
                            children: [
                              Image(image: NetworkImage('https://cdn.pixabay.com/photo/2017/11/10/05/24/select-2935439_1280.png'),height: 200,width: 200,),
                              Text('Select Image',style: TextStyle(color: Colors.cyan))
                            ],
                          ),
                        ),
                      },
                      // DropdownMenu<String>(
                      //   initialSelection: department_.first,
                      //   onSelected: (String? value) {
                      //     // This is called when the user selects an item.
                      //     setState(() {
                      //
                      //       selectedvalue = id_[department_.indexOf(value!)].toString();
                      //       department.text = selectedvalue;
                      //     });
                      //   },
                      //   dropdownMenuEntries: department_.map<DropdownMenuEntry<String>>((String value) {
                      //     return DropdownMenuEntry<String>(value: value, label: value);
                      //   }).toList(),
                      // ),
                      SizedBox(height: 15,),
                      TextFormField(
                        validator: (value){
                          String t = value!.trim();
                          if (t.isEmpty){
                            return "Please Enter From Location";
                          }
                          return null;
                        },
                        controller: fromlocation,
                        decoration: InputDecoration(border: OutlineInputBorder(),label: Text('From Location')),
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        validator: (value){
                          String t = value!.trim();
                          if (t.isEmpty){
                            return "Please Enter to Location";
                          }
                          return null;
                        },
                        controller: tolocation,
                        decoration: InputDecoration(border: OutlineInputBorder(),label: Text('To Location')),
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        validator: (value){
                          String t = value!.trim();
                          if (t.isEmpty){
                            return "Please Enter Your Year";
                          }
                          return null;
                        },
                        controller: academicyear,
                        decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Academic Year')),
                      ),
                      SizedBox(height: 15,),


                      ElevatedButton(style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white), // Set button color to white
                        side: MaterialStateProperty.all(BorderSide(color: Colors.black)), // Set border color to black
                      ), onPressed: (){if (photo.length==0){
                        Fluttertoast.showToast(msg: "Please Select an Image");

                      }
                      else if (formkey.currentState!.validate()){

                        _send_data();

                      }
                      else{
                        return null;
                      }}, child: Text(
                        'Send Request',
                        style: TextStyle(color: Colors.black), // Set text color to black
                      ),)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

      ),
    );
  }
  void _send_data() async{



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/send_bus_pass_request/');
    try {
      final response = await http.post(urls, body: {
        'department':department.text,
        'f_place':fromlocation.text,
        'to_place':tolocation.text,
        'academic_year':academicyear.text,
        'file':photo,
        'lid':lid,


      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          Fluttertoast.showToast(msg: 'Request Sent Successfully');

          Navigator.push(context, MaterialPageRoute(
            builder: (context) => HomePage(),));
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
  File? _selectedImage;
  String? _encodedImage;
  Future<void> _chooseAndUploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
        photo = _encodedImage.toString();
      });
    }
  }

  Future<void> _checkPermissionAndChooseImage() async {
    final PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseAndUploadImage();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
            'Please go to app settings and grant permission to choose an image.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String photo = '';

  String selectedvalue = '';
  List<String> id_=<String>[];
  List<String> department_=<String>[];


  Future<void> viewreply() async {
    List<String> id=<String>[];
    List<String> department=<String>[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/view_department_student/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        department.add(arr[i]['department']);
      }

      setState(() {
        id_ = id;
        department_ = department;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }
}
