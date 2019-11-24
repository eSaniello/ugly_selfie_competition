import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ugly_selfie_competition/providers/user.dart';

class UploadSelfieScreen extends StatefulWidget {
  @override
  _UploadSelfieScreenState createState() => _UploadSelfieScreenState();
}

class _UploadSelfieScreenState extends State<UploadSelfieScreen> {
  // Active image file
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      // ratioX: 1.0,
      // ratioY: 1.0,
      // maxWidth: 512,
      // maxHeight: 512,
      // androidUiSettings: AndroidUiSettings(
      //   toolbarColor: Colors.purple,
      //   toolbarWidgetColor: Colors.white,
      //   toolbarTitle: 'Crop it!',
      // ),
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  TextEditingController capController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<User>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload new selfie'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (_imageFile != null) ...[
              Container(
                padding: EdgeInsets.all(32),
                child: Image.file(_imageFile),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    color: Colors.blue,
                    child: Icon(Icons.crop),
                    onPressed: _cropImage,
                  ),
                  FlatButton(
                    color: Colors.blue,
                    child: Icon(Icons.refresh),
                    onPressed: _clear,
                  ),
                ],
              ),
              Container(
                width: 250,
                child: TextField(
                  controller: capController,
                  decoration: InputDecoration(hintText: 'Write a caption'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: capController.text.length > 1
                    ? Uploader(
                        file: _imageFile,
                        user: userData,
                        caption: capController.text,
                      )
                    : Container(),
              )
            ] else ...[
              Center(
                heightFactor: 2,
                child: Card(
                  elevation: 5,
                  child: Container(
                    width: 200,
                    height: 200,
                    child: IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        size: 100,
                      ),
                      onPressed: () => _pickImage(ImageSource.camera),
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 5,
                child: Container(
                  width: 200,
                  height: 200,
                  child: IconButton(
                    icon: Icon(
                      Icons.photo_library,
                      size: 100,
                    ),
                    onPressed: () => _pickImage(ImageSource.gallery),
                    color: Colors.pink,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;
  final FirebaseUser user;
  final String caption;

  Uploader({Key key, this.file, this.user, this.caption}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://ugly-selfie-competition-715f1.appspot.com');

  StorageUploadTask _uploadTask;

  _startUpload() {
    String filePath = 'selfies/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  void createPost(FirebaseUser userData, String caption) async {
    final StorageTaskSnapshot downloadUrl = (await _uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print('URL Is $url');

    DocumentReference ref = await Firestore.instance.collection("posts").add({
      'uid': userData.uid,
      'username': userData.displayName,
      'likes': [],
      'caption': caption,
      'imageUrl': url,
    });

    print(ref.documentID);
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;
            if (_uploadTask.isComplete) {
              createPost(widget.user, widget.caption);
              // Navigator.of(context).pop();
            }
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_uploadTask.isComplete)
                    Text(
                      '🎉🎉🎉',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        height: 2,
                        fontSize: 30,
                      ),
                    ),
                  LinearProgressIndicator(value: progressPercent),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % ',
                    style: TextStyle(fontSize: 50),
                  ),
                ]);
          });
    } else {
      return FlatButton.icon(
          color: Colors.blue,
          label: Text('Upload'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload);
    }
  }
}
