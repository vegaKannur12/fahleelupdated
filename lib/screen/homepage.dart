import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:fahleelnew/screen/cheweiList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieDemo extends StatefulWidget {
  ChewieDemo({this.title = 'Chewie Demo'});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform? _platform;
  VideoPlayerController? _videoPlayerController1;
  VideoPlayerController? _videoPlayerController2;
  ChewieController? _chewieController;
  bool isEnd = false;
  @override
  void initState() {
    super.initState();
    // _videoPlayerController1 = VideoPlayerController.network(
    //   'http://146.190.8.166/API/add.mp4',
    // );
    // _videoPlayerController2 =
    //     VideoPlayerController.network('http://146.190.8.166/API/Vid.mp4');

_videoPlayerController1=VideoPlayerController.networkUrl(Uri.parse(
        'http://146.190.8.166/API/add.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  _videoPlayerController2=VideoPlayerController.networkUrl(Uri.parse(
        'http://146.190.8.166/API/Vid.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1!,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: false,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );

    _videoPlayerController1!.addListener(() {
      if (_videoPlayerController1!.value.position ==
          _videoPlayerController1!.value.duration) {
        print('video Ended');
        _videoPlayerController2!.dispose();
        setState(() {
          isEnd = true;
        });
      }
    });

    _videoPlayerController2!.addListener(() {
      if (_videoPlayerController2!.value.position ==
          _videoPlayerController2!.value.duration) {
        print('video Ended vid2');
        _videoPlayerController1!.dispose();
        setState(() {
          isEnd = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController1!.dispose();
    _videoPlayerController2!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: ThemeData.light().copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ChewieListItem(
                // This URL doesn't exist - will display an error
                videoPlayerController: VideoPlayerController.network(
                  isEnd
                      ? "http://146.190.8.166/API/add.mp4"
                      : 'http://146.190.8.166/API/Vid.mp4',
                ),
                looping: true,
              ),
            ),
            // Expanded(
            //   child: Center(
            //     child: Chewie(
            //       controller: _chewieController!,
            //     ),
            //   ),
            // ),
            ElevatedButton(
              onPressed: () {
                _chewieController!.enterFullScreen();
              },
              child: Text('Fullscreen'),
            ),
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: () {
            //           setState(() {
            //             _chewieController!.dispose();
            //             _videoPlayerController2!.pause();
            //             _videoPlayerController2!.seekTo(Duration(seconds: 0));
            //             _chewieController = ChewieController(
            //               videoPlayerController: _videoPlayerController1!,
            //               aspectRatio: 3 / 2,
            //               autoPlay: true,
            //               looping: true,
            //             );
            //           });
            //         },
            //         child: Padding(
            //           child: Text("Video 1"),
            //           padding: EdgeInsets.symmetric(vertical: 16.0),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: () {
            //           setState(() {
            //             _chewieController!.dispose();
            //             _videoPlayerController1!.pause();
            //             _videoPlayerController1!.seekTo(Duration(seconds: 0));
            //             _chewieController = ChewieController(
            //               videoPlayerController: _videoPlayerController2!,
            //               aspectRatio: 3 / 2,
            //               autoPlay: true,
            //               looping: true,
            //             );
            //           });
            //         },
            //         child: Padding(
            //           padding: EdgeInsets.symmetric(vertical: 16.0),
            //           child: Text("Error Video"),
            //         ),
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
