import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ig/screens/feed_screen.dart';
import 'package:ig/screens/home_screen.dart';
import 'package:ig/screens/login_screen.dart';
import 'package:ig/screens/signup_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot){
        if (snapshot.hasData) {
          return HomeScreen(userId: snapshot.data.uid,);
        }else{
          return LoginScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Clone IG",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
        color: Colors.black,
      )),
      home: _getScreenId(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        FeedScreen.id: (context) => FeedScreen()
      },
    );
  }
}
