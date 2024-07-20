import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/event.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'screens/add_event_screen.dart';
import 'screens/view_events_screen.dart';
import 'screens/about_screen.dart';
import 'screens/security_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  await Hive.openBox<Event>('events');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _screens = <Widget>[
    AddEventScreen(),
    ViewEventsScreen(),
    AboutScreen(),
    SecurityScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Tarea 8', style: TextStyle(color: Colors.white))),
        backgroundColor: Color.fromARGB(255, 64, 69, 64),
      ),
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.plus),
            label: 'Agregar',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.eye),
            label: 'Ver',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user),
            label: 'Acerca de',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.lock),
            label: 'Peligro',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 88, 91, 88),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
