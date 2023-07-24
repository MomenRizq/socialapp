import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  String ?  name;

  Future<void> signUpWithEmail({required String email , required String pass }) async{
  
     emit(RegisterLoading());
      
      try {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: email!, password: pass!);
       // showSnackBar(ctx,mesaage: "Done successfully " , color: Colors.green);
        await user.user?.updateDisplayName(name);
        emit(RegisterSuccess());
       // Navigator.pushNamed(context, loginPage.id);
      }on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
         emit(RegisterFailure(errorMeassage:'weak-password' ));
        } else if (e.code == 'email-already-in-use') {
           emit(RegisterFailure(errorMeassage:'email-already-in-use' ));
        }
      } catch(e)
      {
        emit(RegisterFailure(errorMeassage:e.toString() ));
      }
     

  }
}
