import 'dart:ui';

import 'package:addictions_flutter/screens/addction_screen/addiction_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConsequencesList extends StatelessWidget {
  ConsequencesList({Key key, this.addictionId}) : super(key: key);

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
                      .collection('consequences')
                      .where("userId", isEqualTo: userSnapshot.data.uid)
                      .where("addictionId", isEqualTo: this.addictionId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    if (snapshot.data.documents.isNotEmpty) {
                      return ListView(
                        children: <Widget>[
                          ...snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            return GestureDetector(
                                child: ListTile(
                                  title: Text(document['name']),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AddictionScreen.routeName,
                                      arguments: AddictionScreenArguments(
                                          addictionId: document.documentID,
                                          addictionName: document['name']));
                                });
                          }).toList(),
                        ],
                      );
                    } else {
                      return ListView(children: <Widget>[
                        ListTile(
                            title: Text('Consequences list is empty',
                                style: TextStyle(fontStyle: FontStyle.italic)))
                      ]);
                    }
                  });
          }),
    );
  }
}
