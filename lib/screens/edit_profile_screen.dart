import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ig/models/user_models.dart';
import 'package:ig/services/database_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ig/services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File _profileImage;
  String _name = '';
  String _bio = '';
  bool _isLoading = false;

  bool _isButtonTapped = false;

  _onTapped() {
    setState(() => _isButtonTapped = !_isButtonTapped);
    if (_isButtonTapped == true) {
    _submit();
    }
    setState(() {
      _isLoading = true;
    });
    print(_isButtonTapped);
  }

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  _handleImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _profileImage = imageFile;
      });
    }
  }

  _displayProfileImage() {
    // No New Profile Image
    if (_profileImage == null) {
      // No Existing Profile Image
      if (widget.user.profileImageUrl.isEmpty) {
        // Display image Placeholder
        return AssetImage('assets/images/user_profile.png');
      } else {
        // User Profile is Already Exists
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      // New Profile Image
      return FileImage(_profileImage);
    }
  }

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      // Update User in Database
      String _profileImageUrl = '';

      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl;
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
            widget.user.profileImageUrl, _profileImage);
      }

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: _displayProfileImage(),
                    ),
                    FlatButton(
                      onPressed: _handleImageFromGallery,
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
                        padding: EdgeInsets.all(10),
                        onPressed: _isButtonTapped ? null : _onTapped,
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
          ],
        ),
      ),
    );
  }
}
