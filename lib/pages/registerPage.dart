import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widgets/customButton.dart';
import '../widgets/customTextField.dart';

class registerPage extends StatelessWidget {
  static String id = "registerPage";
  final _formKey = GlobalKey<FormState>();

  String ?  name;
  String ?  email;
  String ?  pass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: Theme.of(context).primaryColor,
        child:Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.only(top:70 , left: 25 , bottom: 30 ),
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Register" ,style: TextStyle(color:Colors.white , fontSize:30),),
                  const Text("Welcome to social App",style: TextStyle( fontSize:20),),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(50) , topRight:Radius.circular(50) )
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 25,),
                         customTextField(lableText: "Name",hintText: "Enter your name",emptyText: "Name is empty ,write your Name , please.",
                            onchanged: (data){ name = data ; },
                        ),
                        const SizedBox(height: 10,),
                        customTextField(lableText: "Email",hintText: "Enter your email",emptyText: "Email is empty ,write your email , please.",onchanged: (data){ email = data ; }, ),
                        const SizedBox(height: 10,),
                        customTextField(lableText: "Password",hintText: "Enter your password",emptyText: "password is empty ,write your password , please.", obscureText: true , onchanged: (data){ pass = data ; },),
                        const SizedBox(height: 5,),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          //child: Text('Don\'t have an account? Create'),
                          child: Text.rich(
                              TextSpan(
                                  children: [
                                    const TextSpan(
                                        text: "Are you have already account? "),
                                    TextSpan(
                                      text: 'Login',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                        Navigator.pop(context);
                                        },
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme
                                              .of(context)
                                              .primaryColor),
                                    ),
                                  ]
                              )
                          ),
                        ),
                        const SizedBox(height: 15,),
                         customButton(title: "Register", color:Colors.teal ,onTap:()async{
                           signUpWithEmail(context);
                           } ,),

                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signUpWithEmail(BuildContext ctx) async{
    if (_formKey.currentState!.validate()){
      try {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: email!, password: pass!);
        showSnackBar(ctx,mesaage: "Done successfully " , color: Colors.green);
        await user.user?.updateDisplayName(name);
      }on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showSnackBar(ctx,mesaage: 'The password provided is too weak.' , color: Colors.red);
        } else if (e.code == 'email-already-in-use') {
         showSnackBar(ctx,mesaage: 'The account already exists for that email.',color: Colors.red);
        }
      }catch(e){
        showSnackBar(ctx, mesaage: "$e" , color: Colors.red);
      }

  }}
  void showSnackBar(BuildContext ctx ,{String? mesaage , Color? color }) {
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text('$mesaage'),
      duration: Duration(seconds: 5),
    ));
  }
}