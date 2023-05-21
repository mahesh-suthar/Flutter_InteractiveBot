import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class SpotifyPlayerClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        title: Text('Spotify Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Now Playing',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25),
            Image.asset(
              'assets/images/TechVenom.png',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 50),
            Text(
              'Deva Deva',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Arijit Singh, Jonita Gandhi, Pritam Chakraborty, Amitabh Bhattacharya',
              style: TextStyle(
                fontSize: 18,
                wordSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 150,
            ),
            SimpleShadow(
              opacity: 0.20,
              color: Colors.black,
              offset: Offset(3, 7),
              sigma: 30,
              child: Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Text(
              "0:12 _____________________________ 3:14",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 100),
            Text(
              "-------------------------------------------",
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.skip_previous,
                    size: 40,
                  ),
                  onPressed: () {
                    // Handle previous song action
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    size: 40,
                  ),
                  onPressed: () {
                    // Handle play action
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.pause,
                    size: 50,
                  ),
                  onPressed: () {
                    // Handle pause action
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    size: 40,
                  ),
                  onPressed: () {
                    // Handle next song action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
