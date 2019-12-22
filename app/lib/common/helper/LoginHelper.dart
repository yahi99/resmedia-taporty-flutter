
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginHelper {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      FirebaseUser result = (await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password)).user;

      debugPrint("Login di $email eseguito con successo.");

      return result;
    } catch (exception) {
      debugPrint("Errore nel login.");
      debugPrint(exception.toString());

      return null;
    }
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      FirebaseUser result = (await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password)).user;

      debugPrint("Registrazione di $email eseguito con successo.");

      return result;
    } catch (exception) {
      debugPrint("Errore nella registrazione.");
      debugPrint(exception.toString());

      return null;
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount == null) return null;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(authCredential)).user;
    debugPrint("Eseguito l'accesso con Google di ${firebaseUser.email}.");
    //Database().putUser(firebaseUser);

    return firebaseUser;
  }

  Future<void> signOut() async {
    googleSignIn.disconnect();
    debugPrint("Eseguito il logout.");
  }

  Future<void> requestNewPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}