import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/AI_BOT/ChatRoomPage.dart';
import 'package:flutter_auth/Weather/weather_report.dart';
import 'package:flutter_auth/util/menu_widgets.dart';

import '../Keep_Notes/keepNotes.dart';
// import '../Music/SpotifyClone.dart';
import '../YTube/YouTube.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Colors.green.shade700,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.green.shade600,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: '',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // hii mahesh
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tech_Venom",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "@Rdx Applications Dev...",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green[500],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.accessibility,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 28.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Namaste!! You'r Welcome...  ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 30, top: 30, right: 30),
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    //Menu heading
                    children: [
                      Image.asset(
                        'assets/images/TechVenom.png',
                        width: 150,
                        height: 150,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Menu ",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.more_horiz,
                            size: 20,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      //List view of menu
                      Expanded(
                        child: ListView(
                          children: [
                            MenuTile(
                              icon: Icons.favorite,
                              menuOption: "ChatGpt",
                              subTitle: "ask me question...",
                              color: Colors.green.shade600,
                              button: const ChatRoomPage(),
                            ),
                            MenuTile(
                              icon: Icons.book,
                              menuOption: "Keep Notes",
                              subTitle: "write your Imp topics...",
                              color: Colors.black87,
                              button: NotesPage(),
                            ),
                            MenuTile(
                              icon: Icons.play_circle,
                              menuOption: "YouTube",
                              subTitle: "play your fav. video...",
                              color: Colors.red.shade600,
                              button: YouTubeClonePage(),
                            ),
                            MenuTile(
                              icon: Icons.cloud_outlined,
                              menuOption: "Weather Report",
                              subTitle: "Check Today Weather",
                              color: Colors.blue.shade600,
                              button: WeatherPage(),
                            ),
                            // MenuTile(
                            //   icon: Icons.music_note,
                            //   menuOption: "Spotify",
                            //   subTitle: "play your fav. song...",
                            //   color: Colors.green[700],
                            //   button: SpotifyPlayerClone(),
                            // ),
                          ],
                        ),
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
