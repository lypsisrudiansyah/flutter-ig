import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ig/models/user_data.dart';
import 'package:ig/screens/feed_screen.dart';
import 'package:ig/screens/home_screen.dart';
import 'package:ig/screens/login_screen.dart';
import 'package:ig/screens/signup_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot){
        if (snapshot.hasData) {
          Provider.of<UserData>(context, listen: false).currentUserId = snapshot.data.uid;
          return HomeScreen();
        }else{
          return LoginScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => UserData(),
          child: MaterialApp(
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
      ),
    );
  }
}
