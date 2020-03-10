import 'package:flutter/material.dart';

class TriggesListScreen extends StatelessWidget {
  static const routeName = '/create-addiction';

  const TriggesListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Addictions')),
      body: Center(
        child: Text('This is triggers page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('button is pressed'),
        child: Icon(Icons.add),
      ),
    );
  }
}
