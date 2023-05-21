import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/AI_BOT/ChatRoomPage.dart';
import 'package:flutter_auth/MainMenu/home.dart';
import 'package:flutter_auth/Weather/weather_report.dart';
import "package:uuid/uuid.dart";

import 'Keep_Notes/keepNotes.dart';
import 'Login/profile_Screen.dart';
import 'Login/verify.dart';
import 'YTube/YouTube.dart';

var uuid = Uuid();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      initialRoute: 'phone',
      debugShowCheckedModeBanner: false,
      routes: {
        'phone': (context) => MyPhone(),
        'verify': (context) => MyVerify(),
        'home': (context) => MyHome(),
        'chatRoompage': (context) => ChatRoomPage(),
        'WeatherReport': (context) => WeatherPage(),
        'notesPage': (context) => NotesPage(),
        'youTubeClonePage': (context) => YouTubeClonePage(),
      },
    ),
  );
}

const BGColor = Color(0xff43A047);
const botBGColor = Color(0xff43A047);
