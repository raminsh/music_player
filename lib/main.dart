import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:music_player/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.red,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: BotToastInit(),
      navigatorObservers: [
        BotToastNavigatorObserver()
      ],
      home: HomeScreen(),
    );
  }
}