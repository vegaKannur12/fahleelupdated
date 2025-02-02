import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: Container(
          padding: EdgeInsets.all(100),
          color: Colors.black,
          child: VideoPlayerScreen()),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  int? _playBackTime;

  //The values that are passed when changing quality
  Duration? newCurrentPosition;

  String defaultStream =
      // 'http://146.190.8.166/API/Vid.mp4';
      'http://146.190.8.166/API/add.mp4';
  String stream2 = 'http://146.190.8.166/API/add.mp4';
  String stream3 = 'http://146.190.8.166/API/Vid.mp4';

  @override
  void initState() {
    // _controller = VideoPlayerController.network(defaultStream);
    // _controller!.addListener(() {
    //   setState(() {
    //     _playBackTime = _controller!.value.position.inSeconds;
    //   });
    // });
    // _initializeVideoPlayerFuture = _controller!.initialize();
    // super.initState();

super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse( ///mycode
        defaultStream))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

  }

  @override
  void dispose() {
    _initializeVideoPlayerFuture = null;
    _controller?.pause().then((_) {
      _controller!.dispose();
    });
    super.dispose();
  }

  Future<bool> _clearPrevious() async {
    await _controller?.pause();
    return true;
  }

  Future<void> _initializePlay(String videoPath) async {
    // _controller = VideoPlayerController.network(videoPath);
    VideoPlayerController.networkUrl(Uri.parse(  //mycode
        videoPath))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller!.addListener(() {
      setState(() {
        _playBackTime = _controller!.value.position.inSeconds;
      });
    });
    _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
      _controller!.seekTo(newCurrentPosition!);
      _controller!.play();
    });
  }

  void _getValuesAndPlay(String videoPath) {
    newCurrentPosition = _controller!.value.position;
    _startPlay(videoPath);
    print(newCurrentPosition.toString());
  }

  Future<void> _startPlay(String videoPath) async {
    setState(() {
      _initializeVideoPlayerFuture = null;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      _clearPrevious().then((_) {
        _initializePlay(videoPath);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: <Widget>[
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(_controller!),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: FloatingActionButton(
                          onPressed: () {
                            // Wrap the play or pause in a call to `setState`. This ensures the
                            // correct icon is shown.
                            setState(() {
                              // If the video is playing, pause it.
                              if (_controller!.value.isPlaying) {
                                _controller!.pause();
                              } else {
                                // If the video is paused, play it.
                                _controller!.play();
                              }
                            });
                          },
                          // Display the correct icon depending on the state of the player.
                          child: Icon(
                            _controller!.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          _controller!.value.position
                              .toString()
                              .split('.')
                              .first
                              .padLeft(8, "0"),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            _getValuesAndPlay(defaultStream);
                          },
                          child: Text('Default Stream'),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            _getValuesAndPlay(stream2);
                          },
                          child: Text('Video Stream 2'),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            _getValuesAndPlay(stream3);

                            print('Green Button');
                          },
                          child: Text('Video Stream 3'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
