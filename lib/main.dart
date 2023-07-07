import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/pages/chatPage.dart';
import 'package:socialapp/pages/cubit/chat_cubit/chat_page_cubit.dart';
import 'package:socialapp/pages/cubit/login_cubit/login_cubit.dart';
import 'package:socialapp/pages/cubit/register_cubit/cubit/register_cubit.dart';
import 'package:socialapp/pages/loginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialapp/pages/registerPage.dart';
import 'package:dio/dio.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => ChatPageCubit()),

      ],
      child: MaterialApp(
        title: "Social App",
        theme: ThemeData(primaryColor: Colors.teal, accentColor: Colors.amber),
        debugShowCheckedModeBanner: false,
        routes: {
          loginPage.id: (context) => loginPage(),
          registerPage.id: (context) => registerPage(),
          chatPage.id: (context) => chatPage(),
        },
        initialRoute: loginPage.id,
      ),
    );
  }}
