import 'package:addictions_flutter/screens/addction_screen/addiction_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateConsequenceScreen extends StatelessWidget {
  static const routeName = '/create-consequence';

  const CreateConsequenceScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your Consequence'),
      ),
      body: CreateConsequenceForm(),
    );
  }
}

// Create a Form widget.
class CreateConsequenceForm extends StatefulWidget {
  @override
  CreateConsequenceFormState createState() {
    return CreateConsequenceFormState();
  }
}

class CreateConsequenceFormState extends State<CreateConsequenceForm> {
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
                      decoration:
                          InputDecoration(labelText: 'Consequence Name'),
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
                          final CreateConsequenceScreenArguments args =
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
                                .collection('consequence')
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

class CreateConsequenceScreenArguments {
  final String addictionId;

  CreateConsequenceScreenArguments({this.addictionId});
}
