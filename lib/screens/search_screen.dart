import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ig/models/user_models.dart';
import 'package:ig/models/user_data.dart';
import 'package:ig/screens/profile_screen.dart';
import 'package:ig/services/database_service.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  Future<QuerySnapshot> _users;

  _buildUserTile(User user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        backgroundImage: user.profileImageUrl.isEmpty
            ? AssetImage('assets/images/user_profile.png')
            : CachedNetworkImageProvider(user.profileImageUrl),
      ),
      title: Text(user.name),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ProfileScreen(currentUserId: Provider.of<UserData>(context, listen: false).currentUserId,userId: user.id))),
    );
  }

  _clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 50),
              border: InputBorder.none,
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, size: 30),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => _clearSearch(),
              ),
              filled: true,
            ),
            onSubmitted: (input) {
              print(input);
              if (input.isNotEmpty) {
                setState(() {
                  _users = DatabaseService.searchUsers(input);
                });
              }
            },
          ),
        ),
        body: _users == null
            ? Center(child: Text("Search For A User"))
            : FutureBuilder(
                future: _users,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data.documents.length == 0) {
                    return Center(
                      child: Text("No Users Found!, Please Try Again"),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      User user = User.fromDoc(snapshot.data.documents[index]);
                      return _buildUserTile(user);
                    },
                  );
                },
              ));
  }
}
