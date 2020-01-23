import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  static Auth _instance;

  Auth.internal(this.firebaseAuth, this.googleSignIn);

  factory Auth() {
    if (_instance == null) {
      _instance = Auth.internal(FirebaseAuth.instance, GoogleSignIn());
    }
    return _instance;
  }

  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  Future<AuthResult> signInWithEmailAndPassword(String email, String password) async {
    AuthResult result = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return result;
  }

  Future<AuthResult> createUserWithEmailAndPassword(String email, String password) async {
    return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<AuthResult> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount == null) return null;

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    print("Eseguito l'accesso con Google.");
    return await firebaseAuth.signInWithCredential(authCredential);
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    print("Eseguito il logout.");
  }

  Future<void> requestNewPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future reauthenticate(FirebaseUser user, String password) async {
    await user.reauthenticateWithCredential(
      EmailAuthProvider.getCredential(
        email: user.email,
        password: password,
      ),
    );
  }
}
