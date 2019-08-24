import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/src/controllers/FirebaseUserController.dart';
import 'package:easy_firebase/src/generated/Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'package:dash/dash.dart';


/// Sconsiglio l'uso di questa classe.
/// Invece di usare questa classe implementa il mixin nel tuo UserBloc
class FirebaseUserBloc with MixinFirebaseUserManager implements Bloc {
  FirebaseUserController firebaseUserManager;

  @override
  void dispose() {
    firebaseUserManager.close();
  }

  FirebaseUserBloc.instance();
  factory FirebaseUserBloc.of() => $Provider.of<FirebaseUserBloc>();
  factory FirebaseUserBloc.init({@required SecureStorage storage}) {
    final bloc = FirebaseUserBloc.of();
    return bloc;
  }
  static void close() => $Provider.dispose<FirebaseUserBloc>();
}





class EmailPasswordCredential {
  final String email, password;

  EmailPasswordCredential(this.email, this.password);
}