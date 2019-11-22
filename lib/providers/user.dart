import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  FirebaseUser _user;

  User() {
    FirebaseAuth.instance.currentUser().then((userData) {
      _user = userData;
    }).catchError((onError) {
      print(onError);
    });
  }

  FirebaseUser get user {
    return _user;
  }
}
