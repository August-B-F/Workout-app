import 'package:astra/screens/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

class Workouts extends StatefulWidget {
  const Workouts({Key? key}) : super(key: key);
  @override
  State<Workouts> createState() => _Workouts();
}

class _Workouts extends State<Workouts> {
  final _workouts = Hive.box('workouts');
  final taskTime = Hive.box('time');
    @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  static const List<String> trainingPresets = <String>[
    'walk',
    'run',
    'squats',
    'push-ups',
    'lunges',
    'burpees',
    'plank',
    'side plank',
    'shoulder taps',
    'mountain climbers',
    'superman hold',
    'russian twists',
    'v-ups',
    'sit-ups',
    'crunches',
    'rest',
  ];

  void _addToDo(String name, String time, List tasks, List tasksTime) {
    _workouts.add({
      'name': name,
      'time': time,
      'tasks': tasks,
      'tasksTime': tasksTime,
    });
  }

  void _deleteToDo(int index) {
    _workouts.deleteAt(index);
  }

  void _editToDo(
      int index, String name, String time, List tasks, List tasksTime) {
    _workouts.putAt(index, {
      'name': name,
      'time': time,
      'tasks': tasks,
      'tasksTime': tasksTime,
    });
  }

  void _start(int index) {
    taskTime.put('timer', index);
  }

  void _pushAddTodoScreen() {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    String name = '';
    int time = 0;
    List task = [];
    List tasksTime = [];
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                  child: Column(
                    children: [
                      TextField(
                        autofocus: true,
                        textAlign: TextAlign.center,
                        maxLength: 20,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        onSubmitted: (String workOut) {
                          name = workOut;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter workout name...',
                          contentPadding: EdgeInsets.all(16.0),
                          filled: true,
                          fillColor: Color.fromARGB(255, 41, 41, 41),
                        ),
                      ),
                      Text(
                        '$time min',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 227, 9),
                            fontSize: 30),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: Theme(
                          data: ThemeData(canvasColor: Colors.transparent),
                          child: ReorderableListView(
                            buildDefaultDragHandles: false,
                            shrinkWrap: true,
                            children: <Widget>[
                              for (int index = 0;
                                  index < task.length;
                                  index += 1)
                                ListTile(
                                  key: Key('$index'),
                                  title: Text(
                                    task[index],
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${tasksTime[index]}:00',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 141, 141, 141),
                                      fontSize: 15,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ReorderableDragStartListener(
                                        index: index,
                                        child: const Icon(
                                          Icons.drag_handle_outlined,
                                          color: Color.fromARGB(
                                              255, 141, 141, 141),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: const Color.fromARGB(
                                            255, 255, 39, 39),
                                        onPressed: () {
                                          setState(() {
                                            time -= int.parse(tasksTime[index]);
                                            tasksTime.removeAt(index);
                                            task.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                            onReorder: (int oldIndex, int newIndex) => {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final String item = task.removeAt(oldIndex);
                                task.insert(newIndex, item);

                                final String timeItem =
                                    tasksTime.removeAt(oldIndex);
                                tasksTime.insert(newIndex, timeItem);
                              })
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        margin: const EdgeInsets.only(top: 20),
                        color: const Color.fromARGB(0, 42, 43, 46),
                        child: FloatingActionButton(
                          backgroundColor: const Color.fromARGB(255, 0, 227, 9),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: const Icon(
                            Icons.library_add,
                            color: Color.fromARGB(255, 42, 43, 46),
                            size: 30,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              useSafeArea: false,
                              builder: (BuildContext context) {
                                // ignore: no_leading_underscores_for_local_identifiers
                                Duration _time = const Duration(seconds: 0);
                                // ignore: no_leading_underscores_for_local_identifiers
                                String _name = '';
                                return AlertDialog(
                                  backgroundColor:
                                      const Color.fromARGB(255, 34, 34, 34),
                                  title: const Text(
                                    'Add task',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  content: SizedBox(
                                    height: 360,
                                    width: 350,
                                    child: Column(
                                      children: <Widget>[
                                        Autocomplete(
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            if (textEditingValue.text == '') {
                                              return const Iterable<
                                                  String>.empty();
                                            }
                                            return trainingPresets.where(
                                              (String item) {
                                                return item.contains(
                                                    textEditingValue.text
                                                        .toLowerCase());
                                              },
                                            );
                                          },
                                          fieldViewBuilder: (BuildContext
                                                  context,
                                              TextEditingController
                                                  textEditingController,
                                              FocusNode focusNode,
                                              VoidCallback onFieldSubmitted) {
                                            return TextField(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter task name...',
                                                filled: true,
                                                fillColor: Color.fromARGB(
                                                    255, 41, 41, 41),
                                                counterText: "",
                                              ),
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              maxLength: 20,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                              onSubmitted: (String taskName) {
                                                _name = taskName;
                                              },
                                            );
                                          },
                                          optionsViewBuilder: (BuildContext
                                                  context,
                                              void Function(String) onSelected,
                                              Iterable<String> options) {
                                            return Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 130),
                                                height: 100,
                                                width: 240,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: options.map(
                                                      (opt) {
                                                        return InkWell(
                                                          onTap: () {
                                                            onSelected(opt);
                                                          },
                                                          child: Card(
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                27,
                                                                27,
                                                                27),
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Text(
                                                                opt,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          height: 190,
                                          alignment: Alignment.center,
                                          child: ShaderMask(
                                            shaderCallback: (Rect rect) {
                                              return const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 42, 43, 46),
                                                  Color.fromARGB(
                                                      255, 42, 43, 46),
                                                  Colors.transparent,
                                                  Colors.transparent,
                                                  Color.fromARGB(
                                                      255, 42, 43, 46),
                                                  Color.fromARGB(
                                                      255, 42, 43, 46),
                                                ],
                                                stops: [
                                                  0.0,
                                                  0.2,
                                                  0.4,
                                                  0.6,
                                                  0.8,
                                                  1.0
                                                ],
                                              ).createShader(rect);
                                            },
                                            blendMode: BlendMode.dstOut,
                                            child: CupertinoPicker(
                                              looping: true,
                                              itemExtent: 45.0,
                                              onSelectedItemChanged:
                                                  (int index) {
                                                setState(() {
                                                  _time =
                                                      Duration(minutes: index);
                                                });
                                              },
                                              children: List<Widget>.generate(
                                                60,
                                                (int index) {
                                                  return Center(
                                                    child: Text(
                                                      '$index min',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 30),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 15),
                                                child: FloatingActionButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  tooltip: 'Remove',
                                                  child: const Icon(
                                                    Icons.delete_rounded,
                                                    color: Color.fromARGB(
                                                        255, 255, 39, 39),
                                                  ),
                                                ),
                                              ),
                                              FloatingActionButton(
                                                onPressed: () {
                                                  if (_name != '') {
                                                    setState(() {
                                                      task.add(_name);
                                                      tasksTime.add(strDigits(
                                                          _time.inMinutes));
                                                      time += int.parse(
                                                          strDigits(
                                                              _time.inMinutes));
                                                    });
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                tooltip: 'Add',
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Color.fromARGB(
                                                      255, 0, 227, 9),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        tooltip: 'Remove',
                        child: const Icon(
                          Icons.cancel,
                          color: Color.fromARGB(255, 255, 39, 39),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        _addToDo(name, time.toString(), task, tasksTime);
                        Navigator.pop(context);
                      },
                      tooltip: 'Add',
                      child: const Icon(
                        Icons.check,
                        color: Color.fromARGB(255, 0, 227, 9),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _pushEditTodoScreen(int index) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    String name = _workouts.getAt(index)['name'];
    int time = int.parse(_workouts.getAt(index)['time']);
    List task = _workouts.getAt(index)['tasks'];
    List tasksTime = _workouts.getAt(index)['tasksTime'];
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: name,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        maxLength: 20,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        onFieldSubmitted: (String workOut) {
                          name = workOut;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter wotkout name...',
                          contentPadding: EdgeInsets.all(16.0),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromARGB(255, 41, 41, 41),
                        ),
                      ),
                      Text(
                        '$time min',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 227, 9),
                            fontSize: 30),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: Theme(
                          data: ThemeData(canvasColor: Colors.transparent),
                          child: ReorderableListView(
                            buildDefaultDragHandles: false,
                            shrinkWrap: true,
                            children: <Widget>[
                              for (int index = 0;
                                  index < task.length;
                                  index += 1)
                                ListTile(
                                  key: Key('$index'),
                                  title: Text(
                                    task[index],
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${tasksTime[index]}:00',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 141, 141, 141),
                                      fontSize: 15,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ReorderableDragStartListener(
                                        index: index,
                                        child: const Icon(
                                          Icons.drag_handle_outlined,
                                          color: Color.fromARGB(
                                              255, 141, 141, 141),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: const Color.fromARGB(
                                            255, 255, 39, 39),
                                        onPressed: () {
                                          setState(() {
                                            time -= int.parse(tasksTime[index]);
                                            tasksTime.removeAt(index);
                                            task.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                            onReorder: (int oldIndex, int newIndex) => {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final String item = task.removeAt(oldIndex);
                                task.insert(newIndex, item);

                                final String timeItem =
                                    tasksTime.removeAt(oldIndex);
                                tasksTime.insert(newIndex, timeItem);
                              })
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        margin: const EdgeInsets.only(top: 20),
                        color: const Color.fromARGB(0, 42, 43, 46),
                        child: FloatingActionButton(
                          backgroundColor: const Color.fromARGB(255, 0, 227, 9),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: const Icon(
                            Icons.library_add,
                            color: Color.fromARGB(255, 42, 43, 46),
                            size: 30,
                          ),
                          onPressed: () {
                                                        showDialog(
                              context: context,
                              useSafeArea: false,
                              builder: (BuildContext context) {
                                // ignore: no_leading_underscores_for_local_identifiers
                                Duration _time = const Duration(seconds: 0);
                                // ignore: no_leading_underscores_for_local_identifiers
                                String _name = '';
                                return AlertDialog(
                                  backgroundColor:
                                      const Color.fromARGB(255, 34, 34, 34),
                                  title: const Text(
                                    'Add task',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  content: SizedBox(
                                    height: 360,
                                    width: 350,
                                    child: Column(
                                      children: <Widget>[
                                        Autocomplete(
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            if (textEditingValue.text == '') {
                                              return const Iterable<
                                                  String>.empty();
                                            }
                                            return trainingPresets.where(
                                              (String item) {
                                                return item.contains(
                                                    textEditingValue.text
                                                        .toLowerCase());
                                              },
                                            );
                                          },
                                          fieldViewBuilder: (BuildContext
                                                  context,
                                              TextEditingController
                                                  textEditingController,
                                              FocusNode focusNode,
                                              VoidCallback onFieldSubmitted) {
                                            return TextField(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter task name...',
                                                filled: true,
                                                fillColor: Color.fromARGB(
                                                    255, 41, 41, 41),
                                                counterText: "",
                                              ),
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              maxLength: 20,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                              onSubmitted: (String taskName) {
                                                _name = taskName;
                                              },
                                            );
                                          },
                                          optionsViewBuilder: (BuildContext
                                                  context,
                                              void Function(String) onSelected,
                                              Iterable<String> options) {
                                            return Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 130),
                                                height: 100,
                                                width: 240,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: options.map(
                                                      (opt) {
                                                        return InkWell(
                                                          onTap: () {
                                                            onSelected(opt);
                                                          },
                                                          child: Card(
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                27,
                                                                27,
                                                                27),
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Text(
                                                                opt,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          height: 190,
                                          alignment: Alignment.center,
                                          child: ShaderMask(
                                            shaderCallback: (Rect rect) {
                                              return const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 42, 43, 46),
                                                  Color.fromARGB(
                                                      255, 42, 43, 46),
                                                  Colors.transparent,
                                                  Colors.transparent,
                                                  Color.fromARGB(
                                                      255, 42, 43, 46),
                                                  Color.fromARGB(
                                                      255, 42, 43, 46),
                                                ],
                                                stops: [
                                                  0.0,
                                                  0.2,
                                                  0.4,
                                                  0.6,
                                                  0.8,
                                                  1.0
                                                ],
                                              ).createShader(rect);
                                            },
                                            blendMode: BlendMode.dstOut,
                                            child: CupertinoPicker(
                                              looping: true,
                                              itemExtent: 45.0,
                                              onSelectedItemChanged:
                                                  (int index) {
                                                setState(() {
                                                  _time =
                                                      Duration(minutes: index);
                                                });
                                              },
                                              children: List<Widget>.generate(
                                                60,
                                                (int index) {
                                                  return Center(
                                                    child: Text(
                                                      '$index min',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 30),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 15),
                                                child: FloatingActionButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  tooltip: 'Remove',
                                                  child: const Icon(
                                                    Icons.delete_rounded,
                                                    color: Color.fromARGB(
                                                        255, 255, 39, 39),
                                                  ),
                                                ),
                                              ),
                                              FloatingActionButton(
                                                onPressed: () {
                                                  if (_name != '') {
                                                    setState(() {
                                                      task.add(_name);
                                                      tasksTime.add(strDigits(
                                                          _time.inMinutes));
                                                      time += int.parse(
                                                          strDigits(
                                                              _time.inMinutes));
                                                    });
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                tooltip: 'Add',
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Color.fromARGB(
                                                      255, 0, 227, 9),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        tooltip: 'Remove',
                        child: const Icon(
                          Icons.cancel,
                          color: Color.fromARGB(255, 255, 39, 39),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        _editToDo(
                            index, name, time.toString(), task, tasksTime);
                        Navigator.pop(context);
                      },
                      tooltip: 'Add',
                      child: const Icon(
                        Icons.check,
                        color: Color.fromARGB(255, 0, 227, 9),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 13, 13, 13),
            elevation: 0,
            title: const Padding(
              padding: EdgeInsets.only(top: 30, left: 10),
              child: Text(
                "Workouts",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ValueListenableBuilder(
            valueListenable: _workouts.listenable(),
            builder: (context, Box<dynamic> workouts, _) {
              return ListView.builder(
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final workout = workouts.getAt(index) as Map;
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                    child: Container(
                      width: 350,
                      height: 90,
                      padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 41, 41, 41),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                workout['name'],
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 25,
                                    width: 70,
                                    child: TextButton(
                                      onPressed: () {
                                        _start(index);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Navbar(),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 0, 227, 9),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 227, 9),
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        "Start",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(255, 41, 41, 41),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      workout['time'] + ':00',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromARGB(255, 141, 141, 141),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    iconSize: 20,
                                    color: const Color.fromARGB(255, 255, 0, 0),
                                    onPressed: () {
                                      _deleteToDo(index);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    iconSize: 20,
                                    color: const Color.fromARGB(255, 0, 227, 9),
                                    onPressed: () {
                                      _pushEditTodoScreen(index);
                                    },
                                  ),
                                ],
                              ),
                            ],
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
        floatingActionButton: FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
