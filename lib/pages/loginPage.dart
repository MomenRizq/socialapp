
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:socialapp/pages/chatPage.dart';
import 'package:socialapp/pages/registerPage.dart';
import 'package:socialapp/widgets/customButton.dart';
import 'package:socialapp/widgets/customTextField.dart';

import '../helper/showSnackBar.dart';




class loginPage extends StatefulWidget {

  static String id = "loginPage";

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String ?  email;

  String ?  pass;

  bool isLoading = false ;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
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
                    const Text("Login" ,style: TextStyle(color:Colors.white , fontSize:30),),
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
                        customFormTextField(lableText: "Email",hintText: "Enter your email",emptyText: "Email is empty ,write your email , please." ,onchanged: (data){ email = data ; },),
                        const SizedBox(height: 10,),
                        customFormTextField(lableText: "Password",hintText: "Enter your password", obscureText: true ,emptyText: "Password is empty ,write your password , please.", onchanged: (data){ pass = data ; }, ),
                        const SizedBox(height: 5,),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          //child: Text('Don\'t have an account? Create'),
                          child: Text.rich(
                              TextSpan(
                                  children: [
                                    const TextSpan(
                                        text: "Don\'t have an account? "),
                                    TextSpan(
                                      text: 'Create',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                        Navigator.pushNamed(context, registerPage.id,);
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
                      customButton(title: "Login", color:Colors.teal ,onTap: ()async{
                       signInWithEmail(context);
                       },),
                        const Divider(color: Colors.black , height: 50, ),
                        const Text("OR"),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget> [
                            customButton(title: "Google", color:Colors.red , onTap: signInWithGoogle,),
                            customButton(title: "Facebook", color:Colors.blue , onTap: signInWithGoogle,),

                          ],
                        ),
                        /*GestureDetector(
                              onTap: () async{
                                await signInWithGoogle();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(Radius.circular(30))
                                ),
                                child: const Text("Sign in by google" , style: TextStyle(color: Colors.white , fontSize: 20),),

                              ),
                            ),
                          GestureDetector(
                          onTap: () async{
                            await signOut();
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(30))
                            ),
                            child: Text("Sign out " , style: TextStyle(color: Colors.white , fontSize: 20),),

                          ),
                        )*/

                      ],
                    ),
                  ),
              ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithEmail(BuildContext ctx) async{
    if (_formKey.currentState!.validate()){
      isLoading = true ;
      setState(() {
        print("Welcome");
      });
      try {
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email!, password: pass!);
        showSnackBar(ctx ,mesaage: "Success" , color:Colors.green );
        print(user.user?.displayName);
        Navigator.pushNamed(context, chatPage.id , arguments: email);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user- not-found') {
          showSnackBar(ctx,mesaage: 'No user found for that email.' , color: Colors.red);
        } else if (e.code == 'wrong-password') {
          showSnackBar(ctx,mesaage: 'Wrong password provided for that user.' , color: Colors.red);
        }
        else{
          showSnackBar(ctx,mesaage: '$e' , color: Colors.red);
        }
      }
      isLoading = false ;
      setState(() {

      });
    }
  }

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;
    AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    UserCredential authResult = await _auth.signInWithCredential(authCredential);
    User user = await _auth.currentUser!;
    print('user email = ${user.email}');
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    print('sign out');
  }


}

