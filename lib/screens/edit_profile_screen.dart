import 'package:flutter/material.dart';
import 'package:ig/models/user_models.dart';
import 'package:ig/services/database_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _bio = '';

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Update User in Database
      String _profileImageUrl = '';
      User user = User(
          id: widget.user.id,
          name: _name,
          profileImageUrl: _profileImageUrl,
          bio: _bio);
      // Database Update
      DatabaseService.updateUser(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Edit Profile",
            style: TextStyle(color: Colors.black),
          )),
      body: SingleChildScrollView(
        child: Container(
          height: mq.height,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        "https://pbs.twimg.com/profile_images/914894066072113152/pWD-GUwG_400x400.jpg"),
                  ),
                  FlatButton(
                    onPressed: () => print("Change Profile Image"),
                    child: Text("Change Profile Image",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 16)),
                  ),
                  TextFormField(
                    initialValue: _name,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: 30,
                        ),
                        labelText: "Name"),
                    validator: (input) => input.trim().length < 1
                        ? 'Please enter a Valid Name'
                        : null,
                    onSaved: (input) => _name = input,
                  ),
                  TextFormField(
                    initialValue: _bio,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.book,
                          size: 30,
                        ),
                        labelText: "Bio"),
                    validator: (input) => input.trim().length > 150
                        ? 'Please enter a Bio Less Than 150 Characters'
                        : null,
                    onSaved: (input) => _bio = input,
                  ),
                  Container(
                    margin: EdgeInsets.all(40),
                    height: 40,
                    width: 250,
                    child: FlatButton(
                      onPressed: _submit,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text(
                        "Save Profile",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
