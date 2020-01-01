import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ig/models/post_model.dart';
import 'package:ig/models/user_data.dart';
import 'package:ig/services/database_service.dart';
import 'package:ig/services/storage_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _image;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text("Add Photo"),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text("Take Photo"),
                onPressed: () => _handleImage(ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text("Choose From Gallery"),
                onPressed: () => _handleImage(ImageSource.gallery),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Add Photo"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () => _handleImage(ImageSource.camera),
              ),
              SimpleDialogOption(
                child: Text('Choose From Gallery'),
                onPressed: () => _handleImage(ImageSource.gallery),
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);

    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      imageFile = await _cropImage(imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );

    return croppedImage;
    /* Checkpoint */
  }

  _submit() async {
    if (!_isLoading && _image != null && _caption.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      //Create The Post
      String imageUrl = await StorageService.uploadPost(_image);
      Post post = Post(
        imageUrl: imageUrl,
        caption: _caption,
        likes: {},
        authorId: Provider.of<UserData>(context, listen: false).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );

      DatabaseService.createPost(post);

      //Reset Data
      _captionController.clear();

      setState(() {
        _caption = '';
        _image = null;
        _isLoading = false;
      });
      print("success");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Create Post",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _submit,
            )
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              height: mq.height,
              child: Column(
                children: <Widget>[
                  _isLoading
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.blue[200],
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          ),
                        )
                      : 
                      SizedBox.shrink(),
                      GestureDetector(
                          onTap: _showSelectImageDialog,
                          child: Container(
                              height: mq.width,
                              width: mq.width,
                              color: Colors.grey[300],
                              child: _image == null
                                  ? Icon(Icons.add_a_photo,
                                      color: Colors.white70, size: 150)
                                  : Image(
                                      image: FileImage(_image),
                                      fit: BoxFit.cover,
                                    )),
                        ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: _captionController,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(labelText: 'Caption'),
                      onChanged: (input) => _caption = input,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
