import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
        
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
               TextFormField(
                 controller: department,
                 decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Department')),
               ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: fromlocation,
                  decoration: InputDecoration(border: OutlineInputBorder(),label: Text('From Location')),
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: tolocation,
                  decoration: InputDecoration(border: OutlineInputBorder(),label: Text('To Location')),
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: academicyear,
                  decoration: InputDecoration(border: OutlineInputBorder(),label: Text('Academic Year')),
                ),
                SizedBox(height: 15,),


                ElevatedButton(onPressed: (){_send_data();}, child: Text('Send Bus Pass Request'))
              ],
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
}
