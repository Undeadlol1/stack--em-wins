import 'package:addictions_flutter/screens/addction_screen/addiction_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAlternativeScreen extends StatelessWidget {
  static const routeName = '/create-alternative';

  const CreateAlternativeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Positive Alternative'),
      ),
      body: CreateAlternativeForm(),
    );
  }
}

// Create a Form widget.
class CreateAlternativeForm extends StatefulWidget {
  @override
  CreateAlternativeFormState createState() {
    return CreateAlternativeFormState();
  }
}

class CreateAlternativeFormState extends State<CreateAlternativeForm> {
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
                      decoration: InputDecoration(labelText: 'Alternative'),
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
                          final CreateAlternativeScreenArguments args =
                              ModalRoute.of(context).settings.arguments;

                          if (!snapshot.hasData) {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Please login')));
                            return;
                          }
                          if (_formKey.currentState.validate()) {
                            final Map<String, dynamic> payload = {
                              'name': nameController.text,
                              'addictionId': args.addictionId,
                              'userId': (snapshot.data as FirebaseUser).uid
                            };
                            Firestore.instance
                                .collection('alternatives')
                                .add(payload)
                                .then((document) {
                              Navigator.pushNamed(
                                  context, AddictionScreen.routeName,
                                  arguments: AddictionScreenArguments(
                                    addictionId: args.addictionId,
                                    // TODO fix addictionName argument
                                    // NOTE make addiction screen document fetching so addictionName will be unnecessary
                                  ));
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

class CreateAlternativeScreenArguments {
  final String addictionId;

  CreateAlternativeScreenArguments({this.addictionId});
}
