import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants/constant.dart';

const API_KEY = yT_SecretKey;

class YouTubeClonePage extends StatefulWidget {
  @override
  _YouTubeClonePageState createState() => _YouTubeClonePageState();
}

class _YouTubeClonePageState extends State<YouTubeClonePage> {
  List<dynamic> _videos = [];
  bool _isFullscreen = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchVideos('');
  }

  Future<void> fetchVideos(String searchQuery) async {
    var encodedQuery = Uri.encodeComponent(searchQuery);
    var url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=$encodedQuery&key=$API_KEY';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _videos = data['items'];
      });
    } else {
      print('Failed to load videos');
    }
  }

  void openVideoPlayer(String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoId: videoId),
      ),
    );
  }

  void searchVideos() {
    String searchQuery = _searchController.text.trim();

    if (searchQuery.isNotEmpty) {
      fetchVideos(searchQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: 80,
        title: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            " YouTube Clone...!!",
            style: TextStyle(
                fontSize: 23, fontWeight: FontWeight.bold, letterSpacing: 2.5),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.green.shade600,
      ),
      backgroundColor: Colors.white70,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Videos',
                labelStyle: TextStyle(fontSize: 20),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchVideos,
                ),
              ),
              onSubmitted: (value) => searchVideos(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                var video = _videos[index];
                var title = video['snippet']['title'];
                var thumbnail =
                    video['snippet']['thumbnails']['default']['url'];
                var videoId = video['id']['videoId'];

                return ListTile(
                  leading: Image.network(
                    thumbnail,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () => openVideoPlayer(videoId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  VideoPlayerScreen({required this.videoId});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade200,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.green.shade600,
        shadowColor: Colors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        toolbarHeight: 50,
        title: Text(
          'Video PLaying',
        ),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,

          onReady: onPlayerReady,
          //   () {
          //   // Perform any operations on player readiness
          // },
        ),
      ),
    );
  }

  void onPlayerReady() {
    // Perform any operations on player readiness
    print('Player is ready');
  }
}
