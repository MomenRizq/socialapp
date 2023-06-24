import 'package:flutter/material.dart';
import 'package:socialapp/pages/chatPage.dart';
import 'package:socialapp/pages/loginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialapp/pages/registerPage.dart';
import 'package:dio/dio.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Social App",
      theme: ThemeData(
        primaryColor: Colors.teal,
        accentColor: Colors.amber
      ),
      debugShowCheckedModeBanner: false,
      routes: {
       loginPage.id :(context)=> loginPage(),
        registerPage.id :(context)=>registerPage(),
        chatPage.id : (context)=> chatPage(),
      },
      initialRoute:  loginPage.id,
    );
  }
}

