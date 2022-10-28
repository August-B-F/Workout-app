import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _Statistics();
}

class _Statistics extends State<Statistics> {
  final timesTrained = Hive.box('timesTrained');
  List<double> data = [];
  bool monthExist = false;
  bool weekExist = false;
  bool underTextVisible = true;
  int weekSelected = 0;
  int? _sliding = 0;

  void _weekData(int minusWeek) {
    setState(() {
      data.clear();
      DateTime weekStart = DateTime.now()
          .subtract(Duration(days: DateTime.now().weekday - 1))
          .subtract(Duration(days: minusWeek * 7));
      String weekStartString = weekStart.toString().split(' ')[0];
      for (int i = 0; i < 7; i++) {
        for (int i = 0; i < timesTrained.length; i++) {
          if (timesTrained.get(i)['week'][0] == weekStartString) {
            weekExist = true;
            data.add(timesTrained.get(i)['week'][1].toDouble() ?? 0);
          }
        }
        if (weekExist == false) {
          data.add(0);
        }
        weekExist = false;
        weekStart = weekStart.add(const Duration(days: 1));
        weekStartString = weekStart.toString().split(' ')[0];
      }
    });
  }

  void _monthData(int minusMonth) {
    setState(() {
      underTextVisible = false;
      data.clear();
      DateTime monthStart = DateTime(
          DateTime.now().year,
          DateTime.now().month +
              double.parse((minusMonth / 4).toString()).round(),
          1);
      String monthStartString = monthStart.toString().split(' ')[0];
      DateTime days =
          DateTime(DateTime.now().month + 1).subtract(const Duration(days: 1));
      int daysTOT = int.parse(days.toString().split(' ')[0].toString().split('-').last);
      for (int i = 0; i < daysTOT; i++) {
        for (int i = 0; i < timesTrained.length; i++) {
          if (timesTrained.get(i)['week'][0] == monthStartString) {
            monthExist = true;
            data.add(timesTrained.get(i)['week'][1].toDouble() ?? 0);
          }
        }
        if (monthExist == false) {
          data.add(0);
        }
        monthExist = false;
        monthStart = monthStart.add(const Duration(days: 1));
        monthStartString = monthStart.toString().split(' ')[0];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    setState(
      () {
        _weekData(weekSelected);
      },
    );
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 20, right: 40),
        child: Column(
          children: [
            CustomSlidingSegmentedControl(
              children: {
                0: Container(
                  width: 100,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    "weekly",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                1: Container(
                  width: 100,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    "monthly",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              },
              thumbDecoration: BoxDecoration(
                color: const Color.fromARGB(255, 88, 88, 88),
                borderRadius: BorderRadius.circular(20),
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(210, 41, 41, 41),
                borderRadius: BorderRadius.circular(20),
              ),
              initialValue: _sliding,
              onValueChanged: (int? newValue) {
                setState(() {
                  _sliding = newValue;
                  if (_sliding == 0) {
                    underTextVisible = true;
                    _weekData(weekSelected);
                  }
                  if (_sliding == 1) {
                    _monthData(weekSelected);
                  }
                });
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Statistics',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 100, left: 15, right: 15),
                width: 600.0,
                height: 250.0,
                child: Sparkline(
                  data: data,
                  lineWidth: 3,
                  lineColor: const Color.fromARGB(255, 0, 227, 9),
                ),
              ),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: underTextVisible,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Wrap(
                  spacing: 45,
                  children: const [
                    Text(
                      'M',
                      style: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
                    ),
                    Text(
                      'T',
                      style: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
                    ),
                    Text(
                      'W',
                      style: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
                    ),
                    Text(
                      'T',
                      style: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
                    ),
                    Text(
                      'F',
                      style: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
                    ),
                    Text(
                      'S',
                      style: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
                    ),
                    Text(
                      'S',
                      style: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: underTextVisible,
              child: Container(
                margin: const EdgeInsets.only(top: 70),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 41, 41, 41),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                width: 250,
                child: ListTile(
                  title: const Text(
                    'This week',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const Text(
                      '1 oct',
                      style: TextStyle(
                        color: Color.fromARGB(255, 141, 141, 141),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(TablerIcons.chevron_left),
                        color: const Color.fromARGB(255, 0, 227, 9),
                        onPressed: () {
                          weekSelected += 1;
                          if (underTextVisible == true) {
                            _weekData(weekSelected);
                          } else {
                            _monthData(weekSelected);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(TablerIcons.chevron_right),
                        color: const Color.fromARGB(255, 0, 227, 9),
                        onPressed: () {
                          setState(() {
                            weekSelected -= 1;
                            if (underTextVisible == true) {
                              _weekData(weekSelected);
                            } else {
                              _monthData(weekSelected);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
