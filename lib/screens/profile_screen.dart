import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
    print(' sign out');
    return 'error';
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('logout'),
      onPressed: () {
        signOut().whenComplete(() {
          Navigator.pushReplacementNamed(context, '/login');
        });
      },
    );
  }
}
