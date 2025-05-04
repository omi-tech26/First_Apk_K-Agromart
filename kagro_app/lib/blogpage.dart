import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart'; // Required for screen rotation

class VlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<VlogPage> {
  final List<String> _videoPaths = [
    'assets/videos/vlog_video_1.mp4',
    'assets/videos/vlog_video_3.mp4',
  ];

  final List<String> _videoTitles = [
    'Farming',
    'Spraying',
  ];

  late List<VideoPlayerController> _controllers;
  late List<bool> _isPlaying;
  int? _landscapeVideoIndex;

  @override
  void initState() {
    super.initState();
    _initializeVideos();
  }

  void _initializeVideos() {
    _controllers = _videoPaths.map((videoPath) {
      return VideoPlayerController.asset(videoPath)
        ..initialize().then((_) {
          setState(() {});
          _controllers[_controllers.indexWhere((c) => c.dataSource == videoPath)]
              .setLooping(true);
        });
    }).toList();

    _isPlaying = List.generate(_videoPaths.length, (index) => false);
  }

  void _togglePlayPause(int index) {
    setState(() {
      if (_isPlaying[index]) {
        _controllers[index].pause();
      } else {
        _controllers[index].play();
      }
      _isPlaying[index] = !_isPlaying[index];
    });
  }

  void _toggleRotation(int index) {
    setState(() {
      if (_landscapeVideoIndex == index) {
        _resetToPortrait();
      } else {
        _landscapeVideoIndex = index;
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    });
  }

  void _resetToPortrait() {
    setState(() {
      _landscapeVideoIndex = null;
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _resetToPortrait();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_landscapeVideoIndex != null) {
          _resetToPortrait();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: _landscapeVideoIndex == null
            ? AppBar(title: Text('Vlog Page'))
            : null,
        body: Stack(
          children: [
            if (_landscapeVideoIndex == null)
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_controllers.length, (index) {
                    final controller = _controllers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Text(
                            _videoTitles[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: controller.value.isInitialized
                                ? AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller),
                            )
                                : CircularProgressIndicator(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _isPlaying[index]
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 40,
                                ),
                                onPressed: () => _togglePlayPause(index),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.screen_rotation,
                                  size: 40,
                                ),
                                onPressed: () => _toggleRotation(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            if (_landscapeVideoIndex != null)
              Stack(
                children: [
                  Positioned.fill(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: _controllers[_landscapeVideoIndex!].value.isInitialized
                          ? AspectRatio(
                        aspectRatio: _controllers[_landscapeVideoIndex!].value.aspectRatio,
                        child: VideoPlayer(_controllers[_landscapeVideoIndex!]),
                      )
                          : CircularProgressIndicator(),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 40, color: Colors.white),
                      onPressed: _resetToPortrait,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
