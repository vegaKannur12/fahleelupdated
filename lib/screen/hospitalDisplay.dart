import "dart:async";

import "package:fahleelnew/screen/cheweiList.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:flutter_tts/flutter_tts.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:just_audio/just_audio.dart';
import "package:provider/provider.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";

import "package:video_player/video_player.dart";

import "../controller/controller.dart";

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({super.key});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  List<bool> copy = [];
  List<bool> copy1 = [];
  int callcount = 0;
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  Color color1 = Color.fromRGBO(244, 110, 49, 1);
  Color color2 = Color.fromRGBO(54, 54, 54, 1);
  // Alignment hhf = Alignment.topLeft;
  int _start = 10;
  int i = 0;

  Timer? timer;
  FlutterTts flutterTts = FlutterTts();
  double volume = 1.0;
  double tileHeight = 0.0;
  int? tileCount;
  double tileWidth = 0.0;
  // bool showToken = true;
  double pitch = 0.8;
  double speechrate = 0.5;
  List<String> languages = [];

  // String? langCode = "ar-kw";
  // String? langCode = "en-IN";
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<String> updateList = [];
  Color parseColor(String color) {
    print("Colorrrrr...$color");
    String hex = color.replaceAll("#", "");
    if (hex.isEmpty) hex = "ffffff";
    if (hex.length == 3) {
      hex =
          '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
    }
    Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
    return col;
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    Provider.of<Controller>(context, listen: false).getSettings(context);
    Provider.of<Controller>(context, listen: false).getQueueList(context, 0);

    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    // VideoPlayerController.network('https://www.example.com/soundsFile.wav');
// ignore: avoid_single_cascade_in_expression_statements
// VideoPlayerController.networkUrl(Uri.parse(
//         'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
    // _initializeVideoPlayerFuture = _controller!.initialize();

    // _controller!.setLooping(true);
    // play();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false).getSettings(context);
      Provider.of<Controller>(context, listen: false).getQueueList(context, 0);
      _speak("Welcome to city clinic", "init", 0, "en", "0");
      // _speak("Token Number 7,8,8 , proceed to Room 2", "init", 0, "en", "0");

      // speechrate = 0.4;
      // selectedList = List.generate(
      //     Provider.of<Controller>(context, listen: false).queuetList.length,
      //     (index) => false);
      // Future.delayed(Duration(seconds: 20), () {
      getQueueList();
    });
    //  });
    callcount = 0;

    super.initState();
  }
// callapi() async
// {

// }
  // Future<void> runTextToSpeech(
  //     String currentTtsString, double currentSpeechRate) async {
  //   FlutterTts flutterTts;
  //   flutterTts = new FlutterTts();
  //   await flutterTts.awaitSpeakCompletion(true);
  //   await flutterTts.setLanguage("en-IN");
  //   await flutterTts.setVolume(1.0);
  //   await flutterTts.setPitch(1.0);
  //   await flutterTts.isLanguageAvailable("en-IN");
  //   await flutterTts.setSpeechRate(currentSpeechRate);
  //   await flutterTts.speak(currentTtsString);
  // }

  play() {
    _controller!.play();
  }

  @override
  void dispose() {
    // _controller!.dispose();
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).viewPadding;
    //  Timer.periodic(const Duration(minutes: 2), (timer) async {

    //  });
    double topPadding = 8;
    // int totPadding = 2 * botomPadding;

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: null,
      //   child: Text(callcount.toString()),
      // ),
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: size.width * 0.35,
              height: double.infinity,
              child: Consumer<Controller>(
                builder: (context, value, child) {
                  if (value.tileCount == null) {
                    tileCount = 3;
                  } else {
                    tileCount = value.tileCount!;
                  }
                  tileHeight =
                      ((size.height - padding.top - (size.height * 0.13)) /
                              tileCount!) -
                          0.5;

                  if (value.isLoading) {
                    return SpinKitCircle(
                      color: Colors.black,
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 37, 37, 37),
                            // color:
                            //     parseColor(value.settings[0]["theme_clr"].toString()),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(0)),
                          ),
                          height: size.height * 0.13,
                          child: ListTile(
                            onTap: () {
                              _onRefresh();
                            },
                            title: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                value.showToken == 1
                                    ? Container(
                                        width: size.width * 0.13,
                                        child: Text(
                                          "Token",
                                          style: GoogleFonts.aBeeZee(
                                            // textStyle: Theme.of(context)
                                            //     .textTheme
                                            //     .bodyText2,
                                            fontSize: value.fontsize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  width: size.width * 0.16,
                                  child: Text(
                                    "Room No",
                                    style: GoogleFonts.aBeeZee(
                                      // textStyle:
                                      //     Theme.of(context).textTheme.bodyText2,
                                      fontSize: value.fontsize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        value.isLoading
                            ? SpinKitCircle(
                                color: Colors.black,
                              )
                            : Expanded(
                                child: ListView.builder(
                                  key: listKey,
                                  shrinkWrap: true,
                                  // itemCount: 3,
                                  itemCount: value.tileCount == null
                                      ? 3
                                      : value.tileCount! * 2,
                                  itemBuilder: (
                                    context,
                                    index,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.all(0.25),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(0)),
                                            color: value.queuetList1.length >
                                                        index &&
                                                    value.quelistReady &&
                                                    value.selectedTile[index]
                                                ? Colors.blue
                                                : Colors.white
                                            // : parseColor(value.settings[0]
                                            //         ["theme_clr"]
                                            //     .toString())

                                            // index % 2 == 0
                                            //     ? parseColor(value
                                            //         .settings[0]
                                            //             ["theme_clr"]
                                            //         .toString())
                                            //     : Colors.grey[300]
                                            // parseColor(value.settings[0]
                                            //         ["theme_clr"]
                                            //     .toString())
                                            ),
                                        height: index % 2 == 1 ? 0 : tileHeight,
                                        child: ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0, bottom: 0),
                                            child: Row(
                                              children: [
                                                value.showToken == 1
                                                    ? Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        width:
                                                            size.width * 0.13,
                                                        child: Text(
                                                          value.queuetList1
                                                                      .length <=
                                                                  index
                                                              ? ""
                                                              // : value.queuetList[
                                                              //                 index]
                                                              //             [
                                                              //             "isSpeak"] ==
                                                              //         "1"
                                                              //     ? ""
                                                              : "${value.queuetList1[index]["queue_token"]}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          // tokenList[index].tokenNum.toString(),
                                                          style: GoogleFonts
                                                              .aBeeZee(
                                                                  // textStyle: Theme.of(
                                                                  //         context)
                                                                  //     .textTheme
                                                                  //     .bodyText2,
                                                                  fontSize: value
                                                                      .fontsize,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: value.queuetList1.length >
                                                                              index &&
                                                                          value
                                                                              .quelistReady &&
                                                                          value.selectedTile[
                                                                              index]
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .blue
                                                                  // : index % 2 == 0
                                                                  //     ? Colors
                                                                  //         .white
                                                                  //     : parseColor(
                                                                  //         value
                                                                  //             .settings[0]["theme_clr"]
                                                                  //             .toString(),
                                                                  //       ),
                                                                  ),
                                                        ),
                                                      )
                                                    : Container(),
                                                Container(
                                                  width: size.width * 0.16,
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    value.queuetList1.length <=
                                                            index
                                                        ? ""
                                                        // : value.queuetList[
                                                        //                 index][
                                                        //             "isSpeak"] ==
                                                        //         "1"
                                                        //     ? ""
                                                        : value
                                                            .queuetList1[index]
                                                                ["cab_id"]
                                                            .toString()
                                                            .toUpperCase(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.aBeeZee(
                                                        // textStyle:
                                                        //     Theme.of(context)
                                                        //         .textTheme
                                                        //         .bodyText2,
                                                        fontSize:
                                                            value.fontsize,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: value.queuetList1
                                                                        .length >
                                                                    index &&
                                                                value
                                                                    .quelistReady &&
                                                                value.selectedTile[
                                                                    index]
                                                            ? Colors.white
                                                            : Colors.blue
                                                        // : index % 2 == 0
                                                        //     ? Colors.white
                                                        //     : parseColor(
                                                        //         value
                                                        //             .settings[
                                                        //                 0][
                                                        //                 "theme_clr"]
                                                        //             .toString(),
                                                        //       ),
                                                        ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    );
                  }
                },
              ),
            ),
            Consumer<Controller>(
              builder: (context, value, child) {
                return Expanded(
                  child: Container(
                    color: Color.fromARGB(255, 37, 37, 37),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Container(
                            width: double.infinity,
                            // color: Colors.red,
                            height: size.height * 0.13,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  value.isLoading
                                      ? SpinKitChasingDots(
                                          color: Colors.black,
                                        )
                                      : Text(
                                          value.settings[0]["BranchName"] !=
                                                  null
                                              ? value.settings[0]["BranchName"]
                                              : "City Clinic",
                                          style: TextStyle(
                                              fontSize: Provider.of<Controller>(
                                                      context,
                                                      listen: false)
                                                  .fontsize,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(
                          height: size.height * 0.7,
                          // color: Colors.yellow,
                          alignment: Alignment.topCenter,
                          child: ChewieListItem(
                            videoPlayerController:
                                VideoPlayerController.networkUrl(
                              Uri.parse('http://146.190.8.166/API/add.mp4'),
                            )..initialize().then((_) {
                                    // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                    setState(() {});
                                  }),
                            //     VideoPlayerController.network(
                            //   'http://146.190.8.166/API/add.mp4',
                            // ),
                            looping: true,
                            adv_vol: value.adv_vol,
                          ),
                        )
                        // Container(
                        //     height: size.height * 0.6,
                        //     child: _buildVideoPlayerWidget()),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       // pause
      //       if (_controller!.value.isPlaying) {
      //         _controller!.pause();
      //       } else {
      //         // play
      //         _controller!.play();
      //       }
      //     });
      //   },
      //   // icon
      //   child: Icon(
      //     _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
      //   ),
      // ),
    );
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  void initSetting(String lang) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(speechrate);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage(lang);
    // flutterTts.getVoices();
  }

//////////////////////////////////////////////////////////////////////////////
  // void _speak(
  //   String text,
  //   String start,
  //   int i,
  //   String lang,
  //   String isSpeak,
  // ) async {
  //   print("isSpeak-----$i----$isSpeak");
  //   if (isSpeak == "0") {
  //     await flutterTts.setVolume(volume);
  //     await flutterTts.setPitch(pitch);
  //     await flutterTts.setSpeechRate(speechrate);
  //     await flutterTts.awaitSpeakCompletion(true);
  //     await flutterTts.setLanguage('en-IN');
  //   }
  //   if (isSpeak == "1") {
  //     await flutterTts.setVolume(volume);
  //     await flutterTts.setPitch(pitch);
  //     await flutterTts.setSpeechRate(speechrate);
  //     await flutterTts.awaitSpeakCompletion(true);
  //     await flutterTts.setLanguage('ar-kw');
  //   }

  //   print("text----${text}");

  //   if (start != "init") {
  //     print("ii-------$i");

  //     if (i % 2 == 0) {
  //       if (i > 0) {
  //         copy.clear();
  //         int l = listCopy();
  //         print("l------$l");
  //         Provider.of<Controller>(context, listen: false).setColor(i - l, true);
  //       } else {
  //         Provider.of<Controller>(context, listen: false).setColor(i, true);
  //         // listCopy1();
  //       }
  //     }
  //     print(
  //         "zdsd----${Provider.of<Controller>(context, listen: false).selectedTile}");
  //   }

  //   await flutterTts.speak(text);
  //   if (i % 2 == 1) {
  //     Provider.of<Controller>(context, listen: false).setColor(i - 1, false);
  //   }
  //   // if (i % 2 == 1) {
  //   //   if (i > 1) {
  //   //     int l = listCopy1();
  //   //     print("lll---------${l}");

  //   //     Provider.of<Controller>(context, listen: false).setColor(l, false);
  //   //   } else {
  //   //     Provider.of<Controller>(context, listen: false).setColor(i - 1, false);
  //   //   }
  //   // }
  // }

  void _speak(
    String text,
    String start,
    int i,
    String lang,
    String isSpeak,
  ) async {
    print(
        "isspeaakkkk----${Provider.of<Controller>(context, listen: false).speechrate}");
    if (isSpeak == "0") {
      await flutterTts.setVolume(volume);
      await flutterTts.setPitch(pitch);
      await flutterTts.setSpeechRate(
          Provider.of<Controller>(context, listen: false).speechrate);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.setLanguage('en-IN');
      if (start != "init") {
        Provider.of<Controller>(context, listen: false).setColor(i, true);
      }
      await flutterTts.speak(text);
      if (start != "init") {
        print("ii-------$i");

        // if (i % 2 == 0) {
        //   if (i > 0) {
        //     copy.clear();
        //     int l = listCopy();
        //     print("l------$l");
        //     Provider.of<Controller>(context, listen: false).setColor(i - l, true);
        //   } else {
        //     Provider.of<Controller>(context, listen: false).setColor(i, true);
        //     // listCopy1();
        //   }
        // }
        print(
            "zdsd----${Provider.of<Controller>(context, listen: false).selectedTile}");
        if (i % 2 == 1) {
          Provider.of<Controller>(context, listen: false)
              .setColor(i - 1, false);
        }
      }
    }
    if (isSpeak == "1") {
      await flutterTts.setVolume(volume);
      await flutterTts.setPitch(pitch);
      await flutterTts.setSpeechRate(
          Provider.of<Controller>(context, listen: false).speechrate);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.setLanguage('ar-kw');
      await flutterTts.speak(text);
      Provider.of<Controller>(context, listen: false).setColor(i, true);
      // if (i % 2 == 0) {
      //   if (i > 0) {
      //     copy.clear();
      //     int l = listCopy();
      //     print("l------$l");
      //     Provider.of<Controller>(context, listen: false).setColor(i - l, true);
      //   } else {
      //     Provider.of<Controller>(context, listen: false).setColor(i, true);
      //     // listCopy1();
      //   }
      // }
      print(
          "zdsd----${Provider.of<Controller>(context, listen: false).selectedTile}");
      if (i % 2 == 1) {
        Provider.of<Controller>(context, listen: false).setColor(i - 1, false);
      }
    }

    print("text----${text}");

    // if (i % 2 == 1) {
    //   if (i > 1) {
    //     int l = listCopy1();
    //     print("lll---------${l}");

    //     Provider.of<Controller>(context, listen: false).setColor(l, false);
    //   } else {
    //     Provider.of<Controller>(context, listen: false).setColor(i - 1, false);
    //   }
    // }
  }

  playAudio() async {
    final player = AudioPlayer(); // Create a player
    final duration = await player.setUrl(// Load a URL
        'https://foo.com/bar.mp3'); // Schemes: (https: | file: | asset: )
    player.play(); // Play without waiting for completion
    await player.play(); // Play while waiting for completion
    await player.pause(); // Pause but remain ready to play
    await player.seek(Duration(seconds: 10)); // Jump to the 10 second position
    await player.setSpeed(2.0); // Twice as fast
    await player.setVolume(0.5); // Half as loud
    await player.stop();
  }

///////////////////////////////////////////////////////////////////////
  void getQueueList() async {
    String str = "";
    Timer.periodic(Duration(seconds: 7), (timer) {
      //Provider.of<Controller>(context, listen: false).timer

      if (Provider.of<Controller>(context, listen: false).quelistReady) {
        if (i <
            Provider.of<Controller>(context, listen: false)
                .queuetList1
                .length) {
          int voicestatus = int.parse(
              Provider.of<Controller>(context, listen: false).queuetList1[i]
                  ["voice_status"]);
          if (voicestatus % 5 == 0) {
            _speak(
              Provider.of<Controller>(context, listen: false).queuetList1[i]
                  ["msg"],
              "speak",
              i,
              "en",
              Provider.of<Controller>(context, listen: false).queuetList1[i]
                  ["isSpeak"],
            );

            print("i endi--$callcount-");
          }

          updateList.add(Provider.of<Controller>(context, listen: false)
              .queuetList1[i]["queue_id"]);

          i = i + 1;
        } else {
          str = updateList.join(",");
          print("str-----$str");

          Provider.of<Controller>(context, listen: false)
              .updateList(context, str);
          Provider.of<Controller>(context, listen: false)
              .getQueueList(context, i);
          updateList.clear();
          i = 0;
        }
      }
    });
  }
}
