import 'package:addictions_flutter/screens/addction_screen/addiction_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAddictionScreen extends StatelessWidget {
  static const routeName = '/create-addiction';

  const CreateAddictionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your Addiction'),
      ),
      body: CreateAddictionForm(),
    );
  }
}

// Create a Form widget.
class CreateAddictionForm extends StatefulWidget {
  @override
  CreateAddictionFormState createState() {
    return CreateAddictionFormState();
  }
}

class CreateAddictionFormState extends State<CreateAddictionForm> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return StreamBuilder(
        stream: _auth.onAuthStateChanged,
        builder: (context, snapshot) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Addiction Name'),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                          child: RaisedButton(
                        onPressed: () {
                          if (!snapshot.hasData) {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Please login')));
                            return;
                          }
                          if (_formKey.currentState.validate()) {
                            final Map<String, dynamic> payload = {
                              'name': nameController.text,
                              'userId': (snapshot.data as FirebaseUser).uid
                            };
                            print('$payload');
                            Firestore.instance
                                .collection('addictions')
                                // TODO manually add an id
                                .add(payload)
                                .then((document) {
                              Navigator.pushNamed(
                                  context, AddictionScreen.routeName,
                                  arguments: AddictionScreenArguments(
                                      addictionId: document.documentID,
                                      addictionName: nameController.text));
                            });
                          }
                        },
                        child: Text('Submit'),
                      )),
                    ),
                  ],
                ),
              ));
        });
  }
}
