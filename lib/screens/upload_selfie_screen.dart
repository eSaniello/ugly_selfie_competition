import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

class UploadSelfieScreen extends StatefulWidget {
  @override
  _UploadSelfieScreenState createState() => _UploadSelfieScreenState();
}

class _UploadSelfieScreenState extends State<UploadSelfieScreen> {
  File _image;
  String _uploadedFileURL;

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile(FirebaseUser userData) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('selfies/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        if (_uploadedFileURL != null) {
          createPost(userData);
          Navigator.of(context).pop();
        }
      });
    });
  }

  void createPost(FirebaseUser userData) async {
    DocumentReference ref = await Firestore.instance.collection("posts").add({
      'uid': userData.uid,
      'username': userData.displayName,
      'likes': '0',
      'imageUrl': _uploadedFileURL,
    });

    print(ref.documentID);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser userData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Selfie'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Selected Image'),
            _image != null
                ? Image.asset(
                    _image.path,
                    height: 150,
                  )
                : Container(height: 150),
            _image == null
                ? RaisedButton(
                    child: Text('Choose File'),
                    onPressed: chooseFile,
                    color: Colors.cyan,
                  )
                : Container(),
            _image != null
                ? RaisedButton(
                    child: Text('Upload File'),
                    onPressed: () => uploadFile(userData),
                    color: Colors.cyan,
                  )
                : Container(),
            Text('Uploaded Image'),
            _uploadedFileURL != null
                ? Image.network(
                    _uploadedFileURL,
                    height: 150,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
