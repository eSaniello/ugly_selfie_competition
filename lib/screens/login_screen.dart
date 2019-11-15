import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  void storeUser(FirebaseUser userData) async {
    await Firestore.instance
        .collection("users")
        .document(userData.uid)
        .setData({
      'name': userData.displayName,
      'email': userData.email,
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('hi'),
      ),
      body: Container(
        color: Colors.blue,
        width: size.width * .70,
        margin: EdgeInsets.symmetric(horizontal: size.width * .10),
        child: InkWell(
          child: Row(
            children: <Widget>[
//            Container(
//              width: size.width * .10,
//              child: Image.asset(
//                'assets/images/google.jpg',
//                fit: BoxFit.contain,
//              ),
//            ),
              Padding(
                padding: EdgeInsets.only(left: size.width * .05),
                child: Text(
                  'google',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            signInWithGoogle().then((FirebaseUser user) {
              print(user);
//            Navigator.of(context).pop();
              storeUser(user);
              Navigator.of(context).pushReplacementNamed('/home');
            }).catchError((e) => print(e));
          },
        ),
      ),
    );
  }
}
