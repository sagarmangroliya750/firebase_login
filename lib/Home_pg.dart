// ignore_for_file: prefer_const_constructors, camel_case_types, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:firebase_login/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home_pg extends StatefulWidget {

  @override
  State<Home_pg> createState() => _Home_pgState();
}

class _Home_pgState extends State<Home_pg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: Text("Home Page",style:TextStyle(letterSpacing:1.5)),
        backgroundColor:Colors.orange.shade300,
        centerTitle: true,
      ),
      body:Column(
        children: [
          SizedBox(height:30),
          Center(
            child: ElevatedButton(
                style:ElevatedButton.styleFrom(primary:Colors.red.shade300,fixedSize:Size(170, 40)),
                onPressed: () async {
                  final GoogleSignInAccount? googleUser = await GoogleSignIn().signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return dashboard();
                  },));
                  Fluttertoast.showToast(
                      msg: "Google Sign Out Successfully !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.green,
                      fontSize: 16.0
                  );
                }, child: Row(
                   mainAxisAlignment:MainAxisAlignment.spaceBetween,
                   children: [
                       Text("Google SignOut",style:TextStyle(letterSpacing:1.5),),
                       Icon(Icons.logout,size:20)
                   ],)),
             )
           ],
        ),
     );
  }
}
