// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final timesTrained = Hive.box('timesTrained');
  final workouts = Hive.box('workouts');
  final taskTime = Hive.box('time');

  Duration _start = Duration(minutes: 20);
  late AnimationController _controller;
  bool _runing = false;
  bool weekExist = false;
  List task = [];
  List taskT = [];

  late Duration totTime;
  late Timer _timer;
  late int index;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    if (taskTime.get('timer') == null) {
      index = -1;
    } else {
      index = taskTime.get('timer');
    }

    if (taskTime.get('timer') == null) {
      totTime = Duration(minutes: 0);
      _start = Duration(minutes: 0);
    } else if (index != -1) {
      totTime = Duration(minutes: int.parse(workouts.getAt(index)['time']));
      _start = Duration(minutes: int.parse(workouts.getAt(index)['time']));
      taskT.addAll(workouts.getAt(index)['tasksTime']);
      task.addAll(workouts.getAt(index)['tasks']);
    }
    super.initState();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => _timer.cancel());
  }

  void resetTimer() {
    setState(() {
      _controller.reverse();
      if (taskTime.get('timer') == null) {
        _start = Duration(minutes: 0);
      } else if (index != -1) {
        _start = Duration(minutes: int.parse(workouts.getAt(index)['time']));
        totTime = Duration(minutes: int.parse(workouts.getAt(index)['time']));
        taskT.clear();
        taskT.addAll(workouts.getAt(index)['tasksTime']);
        task.clear();
        task.addAll(workouts.getAt(index)['tasks']);
      }
    });
    stopTimer();
  }

  void setCountDown() {
    const reduceSecondsBy = 100;
    setState(() {
      final seconds = _start.inMilliseconds - reduceSecondsBy;
      if (seconds < 0) {
        if (taskT.isEmpty) {
          if (taskTime.get('timer') != null) {
            weekExist = false;
            for (int i = 0; i < timesTrained.length; i++) {
              if (timesTrained.get(i)['week'][0] ==
                  '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}') {
                weekExist = true;
                timesTrained.putAt(
                  i,
                  {
                    'week': [
                      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                      (timesTrained.getAt(timesTrained.length - 1)['week'][1] +
                          1)
                    ],
                  },
                );
              }
            }
            if (weekExist == false) {
              timesTrained.add(
                {
                  'week': [
                    '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                    1
                  ],
                },
              );
            }
          }
          _controller.reverse();
          _timer.cancel();
        } else {
          taskT.removeAt(0);
          task.removeAt(0);
        }
      } else {
        _start = Duration(milliseconds: seconds);
      }
      if (taskT.isEmpty == false) {
        if ((_start.inSeconds -
                    ((totTime.inMinutes - int.parse(taskT[0])) * 60)) /
                (int.parse(taskT[0]) * 60) <=
            0.05) {
          totTime = Duration(minutes: totTime.inMinutes - int.parse(taskT[0]));
          _start = Duration(minutes: totTime.inMinutes);
          taskT.removeAt(0);
          task.removeAt(0);
        } else if (int.parse(taskT[0]) == 0) {
          totTime = Duration(minutes: totTime.inMinutes - int.parse(taskT[0]));
          _start = Duration(minutes: totTime.inMinutes);
          taskT.removeAt(0);
          task.removeAt(0);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(_start.inMinutes.remainder(60));
    final seconds = strDigits(_start.inSeconds.remainder(60));
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          return Scaffold(
            body: Center(
              child: Container(
                margin: EdgeInsets.only(top: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (_runing == false) {
                          startTimer();
                          _controller.forward();
                          _runing = true;
                        } else {
                          stopTimer();
                          _controller.reverse();
                          _runing = false;
                        }
                      },
                      child: Text(
                        '$minutes:$seconds',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 0, 227, 9),
                            fontSize: 150),
                      ),
                    ),
                    if (index != -1)
                      // ignore: prefer_is_empty
                      if (task.length >= 1)
                        Container(
                          width: 600,
                          height: 110,
                          padding: EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 41, 41, 41),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  task[0],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 35),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${taskT[0]}:00',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(127, 141, 141, 141),
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: LinearProgressIndicator(
                                        minHeight: 10,
                                        value: taskT.isEmpty
                                            ? 0
                                            : (_start.inSeconds -
                                                    ((totTime.inMinutes -
                                                            int.parse(
                                                                taskT[0])) *
                                                        60)) /
                                                (int.parse(taskT[0]) * 60 +
                                                    0.1),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color.fromARGB(255, 2, 188, 8)),
                                        backgroundColor: const Color.fromARGB(
                                            255, 41, 41, 41),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        totTime = Duration(
                                            minutes: totTime.inMinutes -
                                                int.parse(taskT[0]));
                                        _start = Duration(
                                            minutes: totTime.inMinutes);
                                        taskT.removeAt(0);
                                        task.removeAt(0);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.skip_next,
                                      size: 40,
                                    ),
                                    color: Color.fromARGB(255, 0, 227, 9),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                    if (task.isEmpty)
                      IconButton(
                        onPressed: () {
                          if (index != -1) {}
                          resetTimer();
                          _runing = false;
                        },
                        icon: Icon(
                          Icons.restart_alt,
                          size: 50,
                        ),
                        color: Color.fromARGB(255, 0, 227, 9),
                      ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButton: Container(
              margin: const EdgeInsets.only(top: 50, right: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.settings,
                    size: 40,
                    color: Color.fromARGB(255, 41, 41, 41),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext cxt) {
                        return Container(
                          padding: const EdgeInsets.only(
                              top: 200, bottom: 200, left: 50, right: 50),
                          child: Material(
                            color: const Color.fromARGB(255, 41, 41, 41),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    margin: const EdgeInsets.only(right: 20),
                                    child: CupertinoButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Icon(Icons.close,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          size: 20),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: const Text(
                                    'Settings',
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    // ignore: avoid_print
                                    print('Timer settings');
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            TablerIcons.clock,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                                top: 4, left: 10),
                                            child: Text(
                                              'Timer',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        TablerIcons.chevron_right,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 250,
                                  alignment: Alignment.center,
                                  height: 1,
                                  color: Color.fromARGB(255, 141, 141, 141),
                                ),
                                ListTile(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext cxt) {
                                        return Container(
                                          padding: const EdgeInsets.only(
                                              top: 280,
                                              bottom: 280,
                                              left: 50,
                                              right: 50),
                                          child: Material(
                                            color: const Color.fromARGB(
                                                255, 41, 41, 41),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 20),
                                                    child: CupertinoButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 20),
                                                    ),
                                                  ),
                                                ),
                                                const Text(
                                                  'About us',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(15),
                                                  margin:
                                                      EdgeInsets.only(top: 20),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Astra is a training app to keep track of how you should train. The app is free and open source. If you have any questions, please contact me via email. ',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 15),
                                                        child: Text(
                                                          'Email: august.frigo@gmail.com',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            TablerIcons.info_circle,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                                top: 4, left: 10),
                                            child: Text(
                                              'About us',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        TablerIcons.chevron_right,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 250,
                                  alignment: Alignment.center,
                                  height: 1,
                                  color: Color.fromARGB(255, 141, 141, 141),
                                ),
                                ListTile(
                                  onTap: () async {
                                    if (!await launchUrl(
                                      Uri.parse(
                                          "https://www.paypal.com/donate/?hosted_button_id=WMAKBERL9DTWG"),
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      throw 'Could not launch';
                                    }
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            TablerIcons.wallet,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                                top: 4, left: 10),
                                            child: Text(
                                              'Support us',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        TablerIcons.chevron_right,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 250,
                                  alignment: Alignment.center,
                                  height: 1,
                                  color: Color.fromARGB(255, 141, 141, 141),
                                ),
                                ListTile(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext cxt) {
                                        return Container(
                                          padding: const EdgeInsets.only(
                                              top: 220,
                                              bottom: 220,
                                              left: 50,
                                              right: 50),
                                          child: Material(
                                            color: const Color.fromARGB(
                                                255, 41, 41, 41),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 20),
                                                    child: CupertinoButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Text(
                                                  'Wish list',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  padding: EdgeInsets.all(10),
                                                  child: TextField(
                                                    autofocus: true,
                                                    maxLines: 10,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                    onSubmitted:
                                                        (String taskName) {
                                                      Navigator.pop(context);
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      isDense: true,
                                                      hintText:
                                                          'What do you want in the app?',
                                                      contentPadding:
                                                          EdgeInsets.all(16.0),
                                                      filled: true,
                                                      fillColor: Color.fromARGB(
                                                          255, 41, 41, 41),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: IconButton(
                                                    icon: Icon(
                                                      TablerIcons.send,
                                                      size: 30,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 227, 9),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            TablerIcons.gift,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                                top: 4, left: 10),
                                            child: Text(
                                              'Wish list',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        TablerIcons.chevron_right,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 250,
                                  alignment: Alignment.center,
                                  height: 1,
                                  color: Color.fromARGB(255, 141, 141, 141),
                                ),
                                ListTile(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext cxt) {
                                        return Container(
                                          padding: const EdgeInsets.only(
                                              top: 220,
                                              bottom: 220,
                                              left: 50,
                                              right: 50),
                                          child: Material(
                                            color: const Color.fromARGB(
                                                255, 41, 41, 41),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 20),
                                                    child: CupertinoButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Text(
                                                  'Bug report',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  padding: EdgeInsets.all(10),
                                                  child: TextField(
                                                    autofocus: true,
                                                    maxLines: 10,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                    onSubmitted:
                                                        (String taskName) {
                                                      Navigator.pop(context);
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      isDense: true,
                                                      hintText:
                                                          'What went wrong?',
                                                      contentPadding:
                                                          EdgeInsets.all(16.0),
                                                      filled: true,
                                                      fillColor: Color.fromARGB(
                                                          255, 41, 41, 41),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: IconButton(
                                                    icon: Icon(
                                                      TablerIcons.send,
                                                      size: 30,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 227, 9),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            TablerIcons.bug,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                                top: 4, left: 10),
                                            child: Text(
                                              'Bug report',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        TablerIcons.chevron_right,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  width: 250,
                                  alignment: Alignment.center,
                                  height: 1,
                                  color: Color.fromARGB(255, 141, 141, 141),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 300),
                child: Column(
                  children: <Widget>[
                    Text(
                      '$minutes:$seconds',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 0, 227, 9),
                          fontSize: 80),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(
                          top: 10, bottom: 10, left: 50, right: 50),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          minHeight: 10,
                          value: taskT.isEmpty
                              ? 0
                              : (_start.inSeconds -
                                      ((totTime.inMinutes -
                                              int.parse(taskT[0])) *
                                          60)) /
                                  (int.parse(taskT[0]) * 60 + 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 0, 227, 9)),
                          backgroundColor:
                              const Color.fromARGB(255, 41, 41, 41),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              if (index != -1) {}
                              resetTimer();
                              _runing = false;
                            },
                            icon: Icon(Icons.restart_alt),
                            color: Color.fromARGB(255, 0, 227, 9),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_runing == false) {
                                startTimer();
                                _controller.forward();
                                _runing = true;
                              } else {
                                stopTimer();
                                _controller.reverse();
                                _runing = false;
                              }
                            },
                            child: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              progress: _controller,
                              size: 50,
                              color: Color.fromARGB(255, 0, 227, 9),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                totTime = Duration(
                                    minutes: totTime.inMinutes -
                                        int.parse(taskT[0]));
                                _start = Duration(minutes: totTime.inMinutes);
                                taskT.removeAt(0);
                                task.removeAt(0);
                              });
                            },
                            icon: Icon(Icons.skip_next),
                            color: Color.fromARGB(255, 0, 227, 9),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 300,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            if (index != -1)
                              // ignore: prefer_is_empty
                              if (task.length >= 1)
                                Container(
                                    alignment: Alignment.center,
                                    width: 300,
                                    height: 75,
                                    padding: EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 41, 41, 41),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          task[0],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                        Text(
                                          '${taskT[0]}:00',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  127, 141, 141, 141)),
                                        ),
                                      ],
                                    )),
                            if (index != -1)
                              if (task.length >= 2)
                                Container(
                                  width: 250,
                                  height: 65,
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(127, 41, 41, 41),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      task[1],
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(127, 141, 141, 141),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                            Container(
                              width: 200,
                              height: 45,
                              margin: EdgeInsets.only(top: 10),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(49, 41, 41, 41),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
