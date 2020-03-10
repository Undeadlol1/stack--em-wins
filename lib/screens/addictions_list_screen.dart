import 'package:addictions_flutter/screens/addction_screen/addiction_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:addictions_flutter/screens/create_addiction_screen.dart';
import 'package:addictions_flutter/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddictionsListScreen extends StatelessWidget {
  const AddictionsListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Addictions')),
      drawer: AppDrawer(),
      body: AddictionsList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.pushNamed(context, CreateAddictionScreen.routeName),
      ),
    );
  }
}

class AddictionsList extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AddictionsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.onAuthStateChanged,
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData)
            return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('addictions')
                    .where("userId", isEqualTo: userSnapshot.data.uid)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> addictionsSnapshot) {
                  if (addictionsSnapshot.hasError)
                    return new Text('Error: ${addictionsSnapshot.error}');
                  if (addictionsSnapshot.connectionState ==
                      ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  return ListView(
                    children: <Widget>[
                      ...addictionsSnapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return GestureDetector(
                            child: ListTile(
                              title: Text(
                                document['name'],
                                style: TextStyle(fontSize: 24),
                              ),
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
                });
          else
            return Center(child: Text('Addictions list is empty'));
        });
  }
}
