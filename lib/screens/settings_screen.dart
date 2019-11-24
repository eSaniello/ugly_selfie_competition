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
    return RaisedButton(
      child: Text('logout'),
      onPressed: () {
        Provider.of<User>(context).signOut().whenComplete(() {
          Navigator.pushReplacementNamed(context, '/login');
        });
      },
    );
  }
}
