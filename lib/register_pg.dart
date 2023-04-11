
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, non_constant_identifier_name, avoid_prints, avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';

class register_pg extends StatefulWidget {
  const register_pg({Key? key}) : super(key: key);

  @override
  State<register_pg> createState() => _register_pgState();
}

class _register_pgState extends State<register_pg> {

  TextEditingController temail    = TextEditingController();
  TextEditingController tpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Scaffold(
        body: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade400,
                      Colors.blueGrey.shade100,
                      Colors.blue
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    transform: GradientRotation(20))),
            child:ListView(
              children: [
                Column(children: [
                  Container(
                    height:40,width:180,margin:EdgeInsets.only(top:220,bottom:10),
                    alignment:Alignment.center,
                    decoration:BoxDecoration(color:Colors.black45,
                      borderRadius:BorderRadius.vertical(bottom:Radius.elliptical(50,5),top:Radius.elliptical(50,5)),
                    ),
                    child:Text("User Register",style:TextStyle(fontSize:18,color:Colors.blue.shade200,fontFamily:"font2")),
                  ),
                ]),
                Container(
                  height:430,
                  width: size.width,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration( color: Colors.black45,borderRadius:BorderRadius.circular(20)),
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top:70, right: 20, left: 20),
                        child: TextField(
                          autofillHints: [AutofillHints.email],
                          keyboardType: TextInputType.emailAddress,
                          enableSuggestions: true,
                          textInputAction: TextInputAction.next,
                          controller: temail,style:TextStyle(color:Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue.shade200),
                                  borderRadius: BorderRadius.circular(30)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              prefixIcon: Icon( Icons.mail_lock_outlined),
                              hintText: "Enter Your Email",
                              hintStyle: TextStyle(color: Colors.white70),
                              labelText: "Email", labelStyle: TextStyle(color: Colors.white70)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 20,left:20,top:20,bottom:30),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: tpassword,style:TextStyle(color:Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(30)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              prefixIcon:
                              Icon(Icons.lock),
                              hintText: "Enter Your Password",
                              hintStyle: TextStyle(color: Colors.white70),
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.white70)),
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: ()  async {
                              String semail = temail.text.trim();
                              String spassword = tpassword.text.trim();
                              try {
                                final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: semail,
                                    password:spassword
                                );
                                print("EMAIL :- $semail");
                                print("PASSWORD :- $spassword");
                                Fluttertoast.showToast(
                                    msg: "User register successfully ",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                setState(() {
                                  temail.text = ""; tpassword.text = "";
                                });
                                Navigator.push(context,MaterialPageRoute(builder: (context) {
                                  return dashboard();
                                },));

                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  Fluttertoast.showToast(
                                      msg: "The password is too weak !",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.red,
                                      fontSize: 16.0
                                  );
                                } else if (e.code == 'email-already-in-use') {
                                  Fluttertoast.showToast(
                                      msg: "The account already exists for that email!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.red,
                                      fontSize: 16.0
                                  );
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Container(
                              height: 50, width: size.width-60,
                              margin: EdgeInsets.only(bottom:60),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(blurRadius: 8, spreadRadius: -3)
                                  ]),
                              alignment: Alignment.center,
                              child:Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width:30),
                                  Text("Register",style:TextStyle(fontSize:25,fontFamily: "font1",letterSpacing:1.5)),
                                  IconButton( tooltip: "Clear All",onPressed: () {
                                    setState(() {
                                      temail.text = ""; tpassword.text = "";
                                    });
                                  }, icon:Icon(Icons.remove_circle_rounded,size:30))
                                ],
                              ),
                            ),
                          ),
                          GFButton(
                            onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder:(context) {
                                return dashboard();
                              },));
                            },
                            text: "Back to Login",textStyle:TextStyle(fontSize:15,fontFamily: 'font3'),
                            shape:GFButtonShape.pills,
                            icon: Icon(Icons.arrow_back_ios_sharp),
                            color:Colors.red.shade300,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
        )
    );
  }
}
