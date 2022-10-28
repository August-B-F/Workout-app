import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'workouts.dart';
import 'statistics.dart';
import 'timer.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);
  @override
  State<Navbar> createState() => _Navbar();
}

class _Navbar extends State<Navbar> {
  int _selectedItem = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  final List<Widget> _children = [
    Statistics(),
    const MyHomePage(),
    const Workouts(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(TablerIcons.chart_line),
                  label: '',
                  backgroundColor: Color.fromARGB(255, 41, 41, 41),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.timelapse),
                  label: '',
                  backgroundColor: Color.fromARGB(255, 41, 41, 41),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.folder_copy),
                  label: '',
                  backgroundColor: Color.fromARGB(255, 41, 41, 41),
                ),
              ],
              backgroundColor: const Color.fromARGB(255, 41, 41, 41),
              selectedItemColor: const Color.fromARGB(255, 0, 227, 9),
              unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
              iconSize: 25,
              elevation: 5,
              selectedFontSize: 0,
              currentIndex: _selectedItem,
              onTap: _onItemTapped,
            ),
            body: _children[_selectedItem]);
      } else {
        return Scaffold(body: _children[_selectedItem]);
      }
    });
  }
}
