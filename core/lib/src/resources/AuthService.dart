import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static AuthService _instance;

  AuthService.internal(this.firebaseAuth, this.googleSignIn);

  factory AuthService() {
    if (_instance == null) {
      _instance = AuthService.internal(FirebaseAuth.instance, GoogleSignIn());
    }
    return _instance;
  }

  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  Future<FirebaseUser> getCurrentUser() async {
    return firebaseAuth.currentUser();
  }

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

  Future reauthenticateWithGoogle(FirebaseUser user) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    await user.reauthenticateWithCredential(
      GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      ),
    );
  }

  Future reauthenticateWithEmailAndPassword(FirebaseUser user, String password) async {
    await user.reauthenticateWithCredential(
      EmailAuthProvider.getCredential(
        email: user.email,
        password: password,
      ),
    );
  }
}
