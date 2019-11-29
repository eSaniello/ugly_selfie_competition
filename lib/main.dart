import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ugly_selfie_competition/providers/user.dart';
import 'package:ugly_selfie_competition/screens/home_screen.dart';
import 'package:ugly_selfie_competition/screens/login_screen.dart';
import 'package:ugly_selfie_competition/screens/upload_selfie_screen.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (ctx) => User(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ugly Selfie Competition',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.orange,
        ),
        home: FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
            builder:
                (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.hasData) {
                // FirebaseUser user = snapshot.data; //this is user data
                return HomeScreen();
              }

              return LoginScreen();
            }),
        onGenerateRoute: (RouteSettings settings) {
          print('build route for ${settings.name}');
          var routes = <String, WidgetBuilder>{
            "/login": (ctx) => LoginScreen(),
            "/home": (ctx) => HomeScreen(),
            '/upload_selfie': (context) => UploadSelfieScreen(),
          };
          WidgetBuilder builder = routes[settings.name];
          return MaterialPageRoute(builder: (ctx) => builder(ctx));
        },
      ),
    );
  }
}
