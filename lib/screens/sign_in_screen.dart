import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign-in';
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _handleSignIn() async {
    setState(() => _isLoading = true);

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    Navigator.pushNamed(context, '/');
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : Container(
                  height: 50,
                  child: SignInButton(Buttons.Google,
                      onPressed: () => _handleSignIn()
                          // .then((FirebaseUser user) => print(user))
                          .catchError((e) => print(e))),
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('button is pressed'),
        child: Icon(Icons.add),
      ),
    );
  }
}
