import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginHelper {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async {
    try {
      FirebaseUser result = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;

      debugPrint("Login di $email eseguito con successo.");

      return result;
    } catch (exception) {
      debugPrint("Errore nel login.");
      debugPrint(exception.toString());

      return null;
    }
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(String email, String password) async {
    try {
      FirebaseUser result = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;

      debugPrint("Registrazione di $email eseguito con successo.");

      return result;
    } catch (exception) {
      debugPrint("Errore nella registrazione.");
      debugPrint(exception.toString());

      return null;
    }
  }

  Future<void> signOut() async {
    googleSignIn.disconnect();
    debugPrint("Eseguito il logout.");
  }

  Future<void> requestNewPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
