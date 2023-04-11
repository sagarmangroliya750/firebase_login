// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/Home_pg.dart';
import 'package:firebase_login/otp_login.dart';
import 'package:firebase_login/register_pg.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {

  TextEditingController temail = TextEditingController();
  TextEditingController tpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.topCenter,
              colors: [Colors.orange.shade200, Colors.orange.shade50])),
      child: Container(
        margin: EdgeInsets.only(top:55),
        decoration:BoxDecoration(image:DecorationImage(image: AssetImage("myimg/firebase_logo.png"),
            opacity: 0.3,alignment: Alignment.topCenter,)),
        child: ListView(
          children: [
            Container(
              height:50,
              decoration:BoxDecoration(color:Colors.orange.shade200),
              alignment:Alignment.center,
              margin:EdgeInsets.only(bottom:90,right:100),
              child: Text("Firebase Logins",
                  style:TextStyle(fontSize: 30,letterSpacing:1.5)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: temail,
                decoration: InputDecoration(hintText:"Enter your email",labelText:"Email",
                    prefixIcon: Icon(Icons.email_outlined,color:Colors.blueGrey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: tpassword,
                decoration: InputDecoration(hintText:"Enter your password",labelText:"Password",
                    prefixIcon: Icon(Icons.lock,color:Colors.green.shade400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(size.width - 25, 47),
                      primary: Colors.green, elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  onPressed: () async {
                    String semail = temail.text.trim();
                    String spassword = tpassword.text.trim();

                    try {
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: semail,
                          password: spassword
                      );
                      AwesomeDialog(
                        context: context,
                        dismissOnTouchOutside:false,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Login',
                        desc: 'Login successfully !',
                        dismissOnBackKeyPress:true,
                        btnCancelOnPress: () {},
                        btnOkOnPress:() {
                          setState(() {
                            temail.text = ""; tpassword.text = "";
                          });
                          Navigator.push(context,MaterialPageRoute(builder:(context) {
                            return Home_pg();
                          },));
                        },
                      ).show();

                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        Fluttertoast.showToast(
                            msg: "No user found for that email !",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.red,
                            fontSize: 16.0
                        );
                      } else if (e.code == 'wrong-password') {
                        Fluttertoast.showToast(
                            msg: "Wrong password pls try again !",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.red,
                            fontSize: 16.0
                        );
                      }
                    }
                  },
                  child: Text("LOGIN", style:TextStyle(fontSize:16,letterSpacing:1.5))),
            ),
            Column(
              children: [
              Divider(
                color:Colors.black38,thickness:0.8,height:50,
                indent:40,endIndent:40,
              ),
              Text("OR . ."),
              InkWell(
                onTap: () {
                   Navigator.push(context,MaterialPageRoute(builder:(context) {
                     return otp_login();
                   },));
                },
                child: Container(
                    width:175,height:40,
                    margin:EdgeInsets.only(top:25),
                    decoration:BoxDecoration(color:Colors.black.withOpacity(0.2),borderRadius:BorderRadius.circular(7)),
                    child:Row(
                      mainAxisAlignment:MainAxisAlignment.start,
                      children: [
                        Icon(Icons.phone_android,size:28),
                        Text("Sign In With OTP",style:TextStyle(letterSpacing:1,color:Colors.black),)
                      ],)
                ),
              ),
                InkWell(
                  onTap: () {
                    signInWithGoogle();
                  },
                  child: Container(
                      width:175,margin:EdgeInsets.only(top:25,bottom:40),
                      decoration:BoxDecoration(color:Colors.white38,borderRadius:BorderRadius.circular(7)),
                      child:Row(children: [
                        Image.asset("myimg/google.png",fit:BoxFit.fill,height:40),
                        Text("Sign In With Google",style:TextStyle(letterSpacing:1,color:Colors.blue),)
                      ],)
                  ),
                ),
              SizedBox(
                width:320,height:44,
                child: GFButton(
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder:(context) {
                     return register_pg();
                    },));
                  },
                  text: "New User?   Register",
                  textStyle:TextStyle(fontSize:16,color:Colors.blueGrey,letterSpacing:1.5),
                  shape: GFButtonShape.standard,
                  type:GFButtonType.outline,color:Colors.black,
                ),
              ),
            ],)
          ],
        ),
      ),
    ));
  }
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,);
    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.push(context,MaterialPageRoute(builder: (context) {
      return Home_pg();
    },));
    Fluttertoast.showToast(
        msg: "Google Sign In Successfully !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green.shade300,
        textColor: Colors.white,
        fontSize: 16.0
    );
    print(userCredential);
  }
}
