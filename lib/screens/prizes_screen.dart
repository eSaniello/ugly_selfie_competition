import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrizeScreen extends StatefulWidget {
  @override
  _PrizeScreenState createState() => _PrizeScreenState();
}

class _PrizeScreenState extends State<PrizeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('prizes')
          .orderBy('prizeNumber', descending: false)
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
                        title: Text(ds['prize']),
                        subtitle: Text('Prize: ${ds['prizeNumber']}'),
                        trailing: ds['prizeNumber'] == 1
                            ? Icon(Icons.star)
                            : Text(''),
                      ),
                    ],
                  )),
            );
          },
        );
      },
    );
  }
}
