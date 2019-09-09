// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Provider.dart';

// **************************************************************************
// BlocProviderGenerator
// **************************************************************************

class $Provider extends Provider {
  static T of<T extends Bloc>() {
    switch (T) {
      case FirebaseSignInBloc:
        {
          return BlocCache.getBlocInstance(
              "FirebaseSignInBloc", () => FirebaseSignInBloc.instance());
        }
      case FirebaseSignUpBloc:
        {
          return BlocCache.getBlocInstance(
              "FirebaseSignUpBloc", () => FirebaseSignUpBloc.instance());
        }
    }
    return null;
  }

  static void dispose<T extends Bloc>() {
    switch (T) {
      case FirebaseSignInBloc:
        {
          BlocCache.dispose("FirebaseSignInBloc");
          break;
        }
      case FirebaseSignUpBloc:
        {
          BlocCache.dispose("FirebaseSignUpBloc");
          break;
        }
    }
  }
}
