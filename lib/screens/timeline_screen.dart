import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TimelineScreen extends StatefulWidget {
  final FirebaseUser user;

  TimelineScreen(this.user);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: Firestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.documents[index];
            return widget.user.uid == ds['uid']
                ? Container()
                : Container(
                    // width: 100,
                    // height: size.height * .50,
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(ds['username']),
                          ),
                          Container(
                            width: size.width,
                            height: size.height * .50,
                            child: Image.network(
                              ds['imageUrl'],
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.favorite_border),
                                onPressed: () {
                                  // likePost(widget.user);
                                  var likes = [];
                                  likes.add(widget.user.uid);
                                  try {
                                    Firestore.instance
                                        .collection('posts')
                                        .document(ds.documentID)
                                        .updateData({'likes': likes});
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
          },
        );
      },
    );
  }
}
