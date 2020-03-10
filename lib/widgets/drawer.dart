import 'package:addictions_flutter/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.onAuthStateChanged,
        builder: (context, snapshot) {
          final FirebaseUser user = snapshot.data;
          return Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: user?.photoUrl == null
                          ? null
                          : BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: NetworkImage(user?.photoUrl)))),
                  decoration:
                      BoxDecoration(color: Theme.of(context).accentColor),
                ),
                ListTile(
                  title: Text('Addictions'),
                  onTap: () => Navigator.pushNamed(context, '/'),
                ),
                ListTile(
                    title: Text(snapshot.hasData ? 'Sign Out' : 'Sign In'),
                    onTap: () {
                      if (snapshot.hasData)
                        _auth.signOut();
                      else
                        Navigator.pushNamed(context, SignInScreen.routeName);
                    }),
              ],
            ),
          );
        });
  }
}
