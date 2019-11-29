import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrizeScreen extends StatefulWidget {
  @override
  _PrizeScreenState createState() => _PrizeScreenState();
}

class _PrizeScreenState extends State<PrizeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        SizedBox(height: size.height * .030),
        Text(
          'Prizes',
          style: TextStyle(
            fontSize: size.width * .070,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * .030),
        Expanded(
          child: StreamBuilder(
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
                              title: Text(
                                ds['prize'],
                                style: TextStyle(
                                  fontSize: size.width * .060,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              subtitle: Text(
                                'Prize: ${ds['prizeNumber']}',
                                style: TextStyle(
                                  fontSize: size.width * .050,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.orange,
                                ),
                              ),
                              trailing: ds['prizeNumber'] == 1
                                  ? Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    )
                                  : Text(''),
                            ),
                          ],
                        )),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
