import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ugly_selfie_competition/providers/user.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Center(
      heightFactor: size.height * .0020,
      child: Container(
        width: size.width * .90,
        height: size.height * .050,
        child: RaisedButton(
          color: Colors.red,
          textColor: Colors.white,
          child: Text(
            'logout',
            style: TextStyle(
              fontSize: size.width * .050,
              fontWeight: FontWeight.w400,
            ),
          ),
          onPressed: () {
            Provider.of<User>(context).signOut().whenComplete(() {
              Navigator.pushReplacementNamed(context, '/login');
            });
          },
        ),
      ),
    );
  }
}
