import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:socialapp/pages/chatPage.dart';
import 'package:socialapp/pages/cubit/chat_cubit/chat_page_cubit.dart';
import 'package:socialapp/pages/cubit/login_cubit/login_cubit.dart';
import 'package:socialapp/pages/registerPage.dart';
import 'package:socialapp/widgets/customButton.dart';
import 'package:socialapp/widgets/customTextField.dart';

import '../helper/showSnackBar.dart';

class loginPage extends StatelessWidget {
  static String id = "loginPage";
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String? email;

  String? pass;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading)
          isLoading = true;
        else if (state is LoginSuccess)
         {
           BlocProvider.of<ChatPageCubit>(context).getMessage();
           Navigator.pushReplacementNamed(
            context,
            chatPage.id,
            arguments: email
          );
           isLoading = false;
         }
        else if (state is LoginFailure)
         { showSnackBar(context,
              mesaage: state.errorMeassage, color: Colors.red);
         isLoading = false;
         }
      },
      builder:(context, state)=> ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          body: Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.only(top: 70, left: 25, bottom: 30),
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      const Text(
                        "Welcome to social App",
                        style: TextStyle(fontSize: 20),
                      ),
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
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 25,
                            ),
                            customFormTextField(
                              lableText: "Email",
                              hintText: "Enter your email",
                              emptyText:
                              "Email is empty ,write your email , please.",
                              onchanged: (data) {
                                email = data;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            customFormTextField(
                              lableText: "Password",
                              hintText: "Enter your password",
                              obscureText: true,
                              emptyText:
                              "Password is empty ,write your password , please.",
                              onchanged: (data) {
                                pass = data;
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                              //child: Text('Don\'t have an account? Create'),
                              child: Text.rich(TextSpan(children: [
                                const TextSpan(
                                    text: "Don\'t have an account? "),
                                TextSpan(
                                  text: 'Create',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                        context,
                                        registerPage.id,
                                      );
                                    },
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ])),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            customButton(
                              title: "Login",
                              color: Colors.teal,
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  isLoading = true;
                                  BlocProvider.of<LoginCubit>(context).signInWithEmail(email: email!, pass: pass!);
                                }
                              },
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 50,
                            ),
                            const Text("OR"),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                customButton(
                                  title: "Google",
                                  color: Colors.red,
                                  onTap:()=> BlocProvider.of<LoginCubit>(context).signInWithGoogle(),
                                ),
                                customButton(
                                  title: "Facebook",
                                  color: Colors.blue,
                                  onTap: ()=> BlocProvider.of<LoginCubit>(context).signInWithGoogle(),
                                ),
                              ],
                            ),
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
      ),
    );
  }



  Future<void> signOut() async {
    await _googleSignIn.signOut();
    print('sign out');
  }
}
