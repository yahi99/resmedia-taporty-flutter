import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


typedef Future<V> FutureCallback<V>();


Future<T> converterFirebaseError<T>(FutureCallback<T> firebaseFuture) async {
  try {
    return await firebaseFuture();
  } on PlatformException catch(error) {
    debugPrint(error.toString());
    switch (error.code) {
      case 'ERROR_INVALID_EMAIL':{
        throw EmailAuthError.INVALID;
      }
      case 'ERROR_USER_NOT_FOUND':{
        throw EmailAuthError.USER_NOT_FOUND;
      }
      case 'ERROR_USER_DISABLED': {
        throw EmailAuthError.USER_DISABLE;
      }
      case 'ERROR_WRONG_PASSWORD': {
        throw PasswordAuthError.WRONG;
      }
      case 'ERROR_EMAIL_ALREADY_IN_USE': {
        throw EmailAuthError.ALREADY_IN_USE;
      }
      default:
        debugPrint(error.toString());
        throw error;
    }
  }
}


Future<bool> secureFirebaseError<T>(FutureCallback<T> firebaseFunction, {
  void adderEmailError(EmailAuthError error), adderPasswordError(PasswordAuthError error),
}) async {
  try {
    await firebaseFunction();
    return true;
  } on EmailAuthError catch(error) {
    adderEmailError(error);
  } on PasswordAuthError catch(error) {
    adderPasswordError(error);
  }
  return false;
}



