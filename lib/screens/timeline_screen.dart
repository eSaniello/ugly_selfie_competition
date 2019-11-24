import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ugly_selfie_competition/providers/user.dart';

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final userData = Provider.of<User>(context).user;

    return StreamBuilder(
      stream: Firestore.instance
          .collection('posts')
          .orderBy('likes', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.documents[index];
            return Container(
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(ds['username']),
                      subtitle: Text(ds['caption']),
                      trailing: index == 0 ? Icon(Icons.star) : Text(''),
                    ),
                    Container(
                      width: size.width,
                      child: Image.network(
                        ds['imageUrl'],
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            ds['likes'].contains(userData.uid)
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          onPressed: () {
                            if (ds['likes'].contains(userData.uid)) {
                              try {
                                Firestore.instance
                                    .collection('posts')
                                    .document(ds.documentID)
                                    .updateData({
                                  'likes':
                                      FieldValue.arrayRemove([userData.uid])
                                });
                              } catch (e) {
                                print(e.toString());
                              }
                            } else {
                              try {
                                Firestore.instance
                                    .collection('posts')
                                    .document(ds.documentID)
                                    .updateData({
                                  'likes': FieldValue.arrayUnion([userData.uid])
                                });
                              } catch (e) {
                                print(e.toString());
                              }
                            }
                          },
                        ),
                        Text('${ds['likes'].length}'),
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
