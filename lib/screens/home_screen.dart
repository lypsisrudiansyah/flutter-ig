import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ig/models/user_data.dart';
import 'package:ig/screens/activity_screen.dart';
import 'package:ig/screens/create_post_screen.dart';
import 'package:ig/screens/feed_screen.dart';
import 'package:ig/screens/profile_screen.dart';
import 'package:ig/screens/search_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {      

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
    final String currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;
    print(Provider.of<UserData>(context, listen: false).currentUserId);
    /* Checkpoint */
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(currentUserId: currentUserId),
          SearchScreen(),
          CreatePostScreen(),
          ActivityScreen(),
          ProfileScreen(currentUserId: currentUserId,userId: currentUserId,),
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
