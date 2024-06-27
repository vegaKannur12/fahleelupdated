import 'package:chewie/chewie.dart';
import 'package:fahleelnew/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ChewieListItem extends StatefulWidget {
  // This will contain the URL/asset path which we want to play
  final VideoPlayerController videoPlayerController;
  final bool looping;
  double? adv_vol;

  ChewieListItem(
      {required this.videoPlayerController,
      required this.looping,
      this.adv_vol});

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  ChewieController? _chewieController;
  double? adv_vol1;
  @override
  void initState() {
    super.initState();
    adv_vol1 = Provider.of<Controller>(context, listen: false).adv_vol;
    print("dssadsads---${adv_vol1}");
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      // Prepare the video to be played and display the first frame
      autoInitialize: true,
      // looping: false,
      looping: widget.looping,
      autoPlay: true,
      allowMuting: true,

      // Errors can occur for example when trying to play a video
      // from a non-existent URL
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
    // print("dssadsads---${widget.adv_vol}");

    _chewieController!.setVolume(0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Chewie(
        controller: _chewieController!,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // IMPORTANT to dispose of all the used resources
    widget.videoPlayerController.dispose();
    _chewieController!.dispose();
  }
}
