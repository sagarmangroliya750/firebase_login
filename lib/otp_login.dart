// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks, non_constant_identifier_names, unnecessary_this, unnecessary_null_comparison, avoid_print, use_build_context_synchronously

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/Home_pg.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class otp_login extends StatefulWidget {
  const otp_login({Key? key}) : super(key: key);

  @override
  State<otp_login> createState() => _otp_loginState();
}

class _otp_loginState extends State<otp_login> {

  TextEditingController tnumber = TextEditingController();
  TextEditingController totp = TextEditingController();
  String VeryfyID = "";
  String pin = "";

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:Colors.orange.shade50,
      appBar:AppBar(
        title:Text("OTP LogIn",style:TextStyle(letterSpacing:1.5),),centerTitle:true,
        backgroundColor:Colors.orange.shade300,
      ),
      body:ListView(children: [
        SizedBox(height:20),
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextField(
            keyboardType: TextInputType.number,maxLength:10,
            controller:tnumber,decoration:InputDecoration(
            prefixText:"+91",prefixStyle:TextStyle(color:Colors.black,fontSize:16),
              border:OutlineInputBorder(borderRadius:BorderRadius.circular(15)),
              hintText:"Enter Your 10-Digit Number",labelText:"Mobile Number",
              prefixIcon:  Icon(Icons.call,color:Colors.green),
              suffixIcon:IconButton(onPressed: () {
                setState(() {
                  tnumber.text = "";
                });
              }, icon:Icon(Icons.clear,color:Colors.red,size:22))
            ),
          ),
        ),
       Column(children: [
         ElevatedButton(style:ElevatedButton.styleFrom
           (fixedSize:Size(130,40),primary:Colors.blueGrey),
             onPressed: () async {
               await FirebaseAuth.instance.verifyPhoneNumber(
                 phoneNumber: '+91 ${tnumber.text.trim()}',
                 verificationCompleted: (PhoneAuthCredential credential) {},
                 verificationFailed: (FirebaseAuthException e) {
                   Fluttertoast.showToast(
                       msg: "Verification Failed !!",
                       toastLength: Toast.LENGTH_SHORT,
                       gravity: ToastGravity.CENTER,
                       timeInSecForIosWeb: 1,
                       backgroundColor: Colors.red,
                       textColor: Colors.white,
                       fontSize: 16.0
                   );
                 },
                 codeSent: (String verificationId, int? resendToken) {
                   setState(() {
                     this.VeryfyID = verificationId;
                   });
                   Fluttertoast.showToast(
                       msg: "Otp sent Successfully",
                       toastLength: Toast.LENGTH_SHORT,
                       gravity: ToastGravity.BOTTOM,
                       timeInSecForIosWeb: 1,
                       backgroundColor: Colors.green,
                       textColor: Colors.white,
                       fontSize: 16.0
                   );
                 },
                 codeAutoRetrievalTimeout: (String verificationId) {},
               );

             }, child:Text("Send OTP",style:TextStyle(
                 fontSize:16,letterSpacing:1.5),)),
         SizedBox(height:30),
         Divider(
           color:Colors.black,thickness:0.3,indent:40,endIndent:40,
         ),
         SizedBox(height:20),
         Padding(
           padding: const EdgeInsets.all(15),
           child: TextField(
             keyboardType: TextInputType.number,
             controller:totp,decoration:InputDecoration(
               border:OutlineInputBorder(borderRadius:BorderRadius.circular(15)),
               hintText:"Enter Your 6-Digit OTP",labelText:"Verify OTP",
               prefixIcon:Icon(Icons.message_outlined,color:Colors.black),
               suffixIcon:IconButton(onPressed: () {
                 setState(() {
                   totp.text = "";
                 });
               }, icon:Icon(Icons.clear,color:Colors.red,size:22))
           ),
           ),
         ),
         ElevatedButton(style:ElevatedButton.styleFrom
           (fixedSize:Size(130,40),primary:Colors.green.shade400),
             onPressed: () async {
               pin = totp.text;
               AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                   verificationId: VeryfyID, smsCode:pin);

               try{
                 final fAuth = FirebaseAuth.instance;
                 final authCred = await fAuth.signInWithCredential(phoneAuthCredential);
                 if(authCred != null) {
                   Fluttertoast.showToast(
                       msg: "Login Successfully !!",
                       toastLength: Toast.LENGTH_SHORT,
                       gravity: ToastGravity.CENTER,
                       timeInSecForIosWeb: 1,
                       backgroundColor: Colors.green,
                       textColor: Colors.white,
                       fontSize: 16.0
                   );
                   Navigator.push(context,MaterialPageRoute(builder: (context) {
                     return Home_pg();
                   },));
                 }
               } on FirebaseAuthException catch (e){
                 print(e.message);
                 Fluttertoast.showToast(
                     msg: "Wrong otp ! plz check again",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.CENTER,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.red,
                     textColor: Colors.white,
                     fontSize: 16.0
                 );
               }
             }, child:Text("Verify OTP",style:TextStyle(
                 fontSize:16,letterSpacing:1.5),))
       ],)
      ]),
    );
  }
}
