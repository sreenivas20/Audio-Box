import 'package:flutter/material.dart';
import 'package:musicplayer/screen/homescreen.dart';
import 'package:musicplayer/screen/splashscreen.dart';
// import 'package:musicplayer/screens/splashscreen.dart';

// import 'splashscreen.dart';s
// import 'package:musicplayer/screens/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Audio Box",
      theme: ThemeData(),
      home: const SplashScreen(),
    );
  }
}
