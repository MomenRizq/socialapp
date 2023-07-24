import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../../../helper/showSnackBar.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithEmail(
      {required String email, required String pass}) async {
    emit(LoginLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (ex) {
    if (ex.code == 'user-not-found') {
      emit(LoginFailure(errorMeassage: "user-not-found"));
    } else if (ex.code == 'wrong-password') {
      emit(LoginFailure(errorMeassage: "wrong-password"));
    }
    } catch (ex) {
    print(ex);
    emit(LoginFailure(errorMeassage:ex.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(LoginLoading());
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      UserCredential authResult =
      await _auth.signInWithCredential(authCredential);
      User user = await _auth.currentUser!;
      print('user email = ${user.email}');
      emit(LoginSuccess());
    } on Exception catch (e) {
      emit(LoginFailure(errorMeassage:e.toString()));
    }
  }
}
