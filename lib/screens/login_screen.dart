import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:ugly_selfie_competition/providers/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void storeUser(FirebaseUser userData) async {
    await Firestore.instance
        .collection("users")
        .document(userData.uid)
        .setData({
      'name': userData.displayName,
      'email': userData.email,
    });
  }

  Future<void> loadingModal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please wait'),
          content: Container(
            child: LinearProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xfff6c4cd),
      appBar: AppBar(
        title: Text('Ugly Selfie Competition'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              // width: size.width * .10,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            'Please sign in 🥴',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: size.width * .08),
          ),
          SizedBox(
            height: size.height * .10,
          ),
          Container(
            color: Colors.blue,
            width: size.width * .70,
            margin: EdgeInsets.symmetric(horizontal: size.width * .10),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Container(
                    width: size.width * .10,
                    child: Image.asset(
                      'assets/images/google.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * .05),
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                loadingModal();
                Provider.of<User>(context)
                    .signInWithGoogle()
                    .then((FirebaseUser user) {
                  storeUser(user);
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushReplacementNamed('/home', arguments: user);
                }).catchError((e) => print(e));
              },
            ),
          ),
        ],
      ),
    );
  }
}
