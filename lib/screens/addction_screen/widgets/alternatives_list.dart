import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlternativesList extends StatelessWidget {
  AlternativesList({Key key, this.addictionId}) : super(key: key);

  final String addictionId;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: _auth.onAuthStateChanged,
          builder: (context, userSnapshot) {
            if (userSnapshot.hasData)
              return StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('alternatives')
                      .where("userId", isEqualTo: userSnapshot.data.uid)
                      .where("addictionId", isEqualTo: this.addictionId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    if (snapshot.data.documents.isEmpty) {
                      return ListView(children: <Widget>[
                        ListTile(
                            title: Text('Alternatives list is empty',
                                style: TextStyle(fontStyle: FontStyle.italic)))
                      ]);
                    } else {
                      return ListView(
                        children: <Widget>[
                          ...snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            return ListTile(title: Text(document['name']));
                          }).toList(),
                        ],
                      );
                    }
                  });
          }),
    );
  }
}
