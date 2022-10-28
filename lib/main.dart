import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/navbar.dart';

void main() async {
  await Hive.initFlutter();

  // ignore: unused_local_variable
  var workouts = await Hive.openBox('workouts');
   // ignore: unused_local_variable
  var time = await Hive.openBox('time');
  // ignore: unused_local_variable
  var timesTrained = await Hive.openBox('timesTrained');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 255, 255, 255),
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 13, 13, 13),
          secondary: const Color.fromARGB(255, 41, 41, 41),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 13, 13, 13),
      ),
      home: const Navbar(),
    );
  }
}
