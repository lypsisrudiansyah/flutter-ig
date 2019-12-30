import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ig/screens/activity_screen.dart';
import 'package:ig/screens/create_post_screen.dart';
import 'package:ig/screens/feed_screen.dart';
import 'package:ig/screens/profile_screen.dart';
import 'package:ig/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {

  final String userId;

  HomeScreen({
    this.userId
  });         

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Instagram",
          style: TextStyle(
              color: Colors.black, fontFamily: "Billabong", fontSize: 35),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(),
          SearchScreen(),
          CreatePostScreen(),
          ActivityScreen(),
          ProfileScreen(userId: widget.userId,),
          /* Checkpoint */
        ],
        onPageChanged: (int index) {
          setState(() {
             _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
          backgroundColor: Colors.white,
          currentIndex: _currentTab,
          onTap: (int index) {
            setState(() {
              _currentTab = index;
            });
            _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInCirc);
          },
          activeColor: Colors.black,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
              Icons.home,
              size: 32,
            )),
            BottomNavigationBarItem(
                icon: Icon(
              Icons.search,
              size: 32,
            )),
            BottomNavigationBarItem(
                icon: Icon(
              Icons.photo_camera,
              size: 32,
            )),
            BottomNavigationBarItem(
                icon: Icon(
              Icons.notifications,
              size: 32,
            )),
            BottomNavigationBarItem(
                icon: Icon(
              Icons.account_circle,
              size: 32,
            )),
          ]),
    );
  }
}
