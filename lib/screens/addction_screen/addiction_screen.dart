import 'package:addictions_flutter/screens/addction_screen/widgets/alternatives_list.dart';
import 'package:addictions_flutter/screens/addction_screen/widgets/consequences_list.dart';
import 'package:addictions_flutter/screens/addction_screen/widgets/triggers_list.dart';
import 'package:addictions_flutter/screens/create_alternative_screen.dart';
import 'package:addictions_flutter/screens/create_consequence_screen.dart';
import 'package:addictions_flutter/screens/create_trigger_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AddictionScreen extends StatelessWidget {
  static const routeName = '/addiction_screen';

  const AddictionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
    final AddictionScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    const boldText = TextStyle(fontWeight: FontWeight.bold, fontSize: 19);
    return Scaffold(
      appBar: AppBar(title: Text('${args.addictionName}')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.mood),
              title: Text(
                'Alternatives',
                style: boldText,
              )),
          Divider(),
          AlternativesList(addictionId: args.addictionId),
          Divider(),
          ListTile(
              leading: Icon(Icons.warning),
              title: Text(
                'Triggers',
                style: boldText,
              )),
          Divider(),
          TriggersList(addictionId: args.addictionId),
          Divider(),
          ListTile(
              leading: Icon(Icons.mood_bad),
              title: Text(
                'Consequences',
                style: boldText,
              )),
          Divider(),
          ConsequencesList(addictionId: args.addictionId),
        ],
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        // animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(size: 22.0),
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        // TODO
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        children: [
          SpeedDialChild(
            child: Icon(Icons.mood),
            backgroundColor: Colors.blue,
            label: 'Alternative',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.pushNamed(
                context, CreateAlternativeScreen.routeName,
                arguments: CreateAlternativeScreenArguments(
                    addictionId: args.addictionId)),
          ),
          SpeedDialChild(
            child: Icon(Icons.mood_bad),
            backgroundColor: Colors.deepPurpleAccent,
            label: 'Consequence',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.pushNamed(
                context, CreateConsequenceScreen.routeName,
                arguments: CreateConsequenceScreenArguments(
                    addictionId: args.addictionId)),
          ),
          SpeedDialChild(
            child: Icon(Icons.warning),
            backgroundColor: Colors.red,
            label: 'Trigger',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.pushNamed(
                context, CreateTriggerScreen.routeName,
                arguments: CreateTriggerScreenArguments(
                    addictionId: args.addictionId)),
          ),
        ],
      ),
    );
  }
}

class AddictionScreenArguments {
  final String addictionId;
  final String addictionName;

  AddictionScreenArguments({this.addictionName, this.addictionId});
}
