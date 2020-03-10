import 'package:addictions_flutter/screens/addction_screen/addiction_screen.dart';
import 'package:addictions_flutter/screens/addictions_list_screen.dart';
import 'package:addictions_flutter/screens/create_addiction_screen.dart';
import 'package:addictions_flutter/screens/create_alternative_screen.dart';
import 'package:addictions_flutter/screens/create_consequence_screen.dart';
import 'package:addictions_flutter/screens/create_trigger_screen.dart';
import 'package:addictions_flutter/screens/sign_in_screen.dart';
import 'package:addictions_flutter/screens/triggers_list_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Addictions app',
      initialRoute: '/',
      routes: {
        '/': (context) => AddictionsListScreen(),
        '/triggers': (context) => TriggesListScreen(),
        CreateAddictionScreen.routeName: (context) => CreateAddictionScreen(),
        CreateTriggerScreen.routeName: (context) => CreateTriggerScreen(),
        CreateConsequenceScreen.routeName: (context) =>
            CreateConsequenceScreen(),
        CreateAlternativeScreen.routeName: (context) =>
            CreateAlternativeScreen(),
        AddictionScreen.routeName: (context) => AddictionScreen(),
        SignInScreen.routeName: (context) => SignInScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  BottomBar({Key key}) : super(key: key);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Addictions'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Triggers'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('Journal'),
          ),
        ],
      ),
    );
  }
}
