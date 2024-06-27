// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// import '../controller/controller.dart';

// class YoutubeAppDemo extends StatefulWidget {
//   @override
//   _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
// }

// class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
//   late YoutubePlayerController _controller;
//   Future<void>? _initializeVideoPlayerFuture;

//   Color color1 = Color.fromRGBO(244, 110, 49, 1);
//   Color color2 = Color.fromRGBO(54, 54, 54, 1);
//   // Alignment hhf = Alignment.topLeft;
//   int _start = 10;
//   int i = 0;
//   int selectedTile = 0;
//   // List<bool> selectedList = [];
//   Timer? timer;
//   FlutterTts flutterTts = FlutterTts();
//   double volume = 1.0;
//   double tileHeight = 0.0;
//   int? tileCount;
//   double tileWidth = 0.0;
//   // bool showToken = true;
//   double pitch = 1.0;
//   double speechrate = 0.5;
//   List<String> languages = [];
//   // String? langCode = "ar-kw";
//   String? langCode = "en-IN";
//   RefreshController _refreshController =
//       RefreshController(initialRefresh: false);
//   final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
//   List<String> updateList = [];
//   Color parseColor(String color) {
//     print("Colorrrrr...$color");
//     String hex = color.replaceAll("#", "");
//     if (hex.isEmpty) hex = "ffffff";
//     if (hex.length == 3) {
//       hex =
//           '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
//     }
//     Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
//     return col;
//   }

//   void _onRefresh() async {
//     await Future.delayed(Duration(milliseconds: 1000));
//     Provider.of<Controller>(context, listen: false).getSettings(context);
//     _refreshController.refreshCompleted();
//   }

//   List<String> _videoIds = [
//     'tcodrIK2P_I',
//     'H5v3kku4y6Q',
//     'nPt8bK2gbaU',
//     'K18cpp_-gP8',
//     'iLnmTe5Q2Qw',
//     '_WoCV4c6XOE',
//     'KmzdUe0RSJo',
//     '6jZDSSZZxjQ',
//     'p2lYr3vM_1w',
//     '7QUtEmBT_-w',
//     '34_PXCzGw1M'
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       params: const YoutubePlayerParams(
//         showControls: true,
//         mute: false,
//         showFullscreenButton: true,
//         loop: false,
//       ),
//     );

//     _controller.setFullScreenListener(
//       (isFullScreen) {
//         log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
//       },
//     );

//     _controller.loadPlaylist(
//       list: _videoIds,
//       listType: ListType.playlist,
//       startSeconds: 136,
//     );

//     _speak("Welcome to city clinic", "init", 0, "en");
//     print("pishku----");
//     Provider.of<Controller>(context, listen: false).getSettings(context);

//     Provider.of<Controller>(context, listen: false).getQueueList(context, 0);

//     // selectedList = List.generate(
//     //     Provider.of<Controller>(context, listen: false).queuetList.length,
//     //     (index) => false);
//     getQueueList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var padding = MediaQuery.of(context).viewPadding;
//     Size size = MediaQuery.of(context).size;
//     double topPadding = 8;
//     return YoutubePlayerScaffold(
//       controller: _controller,
//       builder: (context, player) {
//         return Scaffold(
//           body: SafeArea(
//             child: Row(
//               children: [
//                 Container(
//                   width: size.width * 0.4,
//                   height: double.infinity,
//                   child: Consumer<Controller>(
//                     builder: (context, value, child) {
//                       if (value.tileCount == null) {
//                         tileCount = 3;
//                       } else {
//                         tileCount = value.tileCount;
//                       }
//                       tileHeight =
//                           ((size.height - padding.top - (size.height * 0.13)) /
//                                   tileCount!) -
//                               0.5;
//                       if (value.isLoading) {
//                         return SpinKitCircle(
//                           color: Colors.black,
//                         );
//                       } else {
//                         return Column(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Color.fromARGB(255, 37, 37, 37),
//                                 // color:
//                                 //     parseColor(value.settings[0]["theme_clr"].toString()),
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(5)),
//                               ),
//                               height: size.height * 0.13,
//                               child: ListTile(
//                                 onTap: () {
//                                   _onRefresh();
//                                 },
//                                 title: Row(
//                                   // mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     value.showToken == 1
//                                         ? Container(
//                                             width: size.width * 0.12,
//                                             child: Text(
//                                               "Token",
//                                               style: GoogleFonts.aBeeZee(
//                                                 textStyle: Theme.of(context)
//                                                     .textTheme
//                                                     .bodyText2,
//                                                 fontSize: value.fontsize,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           )
//                                         : Container(),
//                                     Container(
//                                       width: value.showToken == 1
//                                           ? size.width * 0.68
//                                           : size.width * 0.2,
//                                       child: Text(
//                                         "Token",
//                                         style: GoogleFonts.aBeeZee(
//                                           textStyle: Theme.of(context)
//                                               .textTheme
//                                               .bodyText2,
//                                           fontSize: value.fontsize,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       width: size.width * 0.15,
//                                       child: Text(
//                                         "Room No",
//                                         style: GoogleFonts.aBeeZee(
//                                           textStyle: Theme.of(context)
//                                               .textTheme
//                                               .bodyText2,
//                                           fontSize: value.fontsize,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             value.isLoading
//                                 ? SpinKitCircle(
//                                     color: Colors.black,
//                                   )
//                                 : Expanded(
//                                     child: ListView.builder(
//                                       key: listKey,
//                                       shrinkWrap: true,
//                                       // itemCount: 3,
//                                       itemCount: value.tileCount == null
//                                           ? 3
//                                           : value.tileCount!,
//                                       itemBuilder: (
//                                         context,
//                                         index,
//                                       ) {
//                                         // _speak(value.queuetList[index]["msg"], "speak", index);
//                                         return Padding(
//                                           padding: const EdgeInsets.all(0.25),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     const BorderRadius.all(
//                                                         Radius.circular(5)),
//                                                 color: value.queuetList.length >
//                                                             index &&
//                                                         value.quelistReady &&
//                                                         value
//                                                             .selectedTile[index]
//                                                     ? Color.fromARGB(
//                                                         255, 238, 93, 83)
//                                                     : index % 2 == 0
//                                                         ? parseColor(value
//                                                             .settings[0]
//                                                                 ["theme_clr"]
//                                                             .toString())
//                                                         : Colors.grey[300]
//                                                 // parseColor(value.settings[0]
//                                                 //         ["theme_clr"]
//                                                 //     .toString())
//                                                 ),
//                                             height: tileHeight,
//                                             child: ListTile(
//                                               title: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 0, bottom: 0),
//                                                 child: Row(
//                                                   // mainAxisAlignment: MainAxisAlignment.start,
//                                                   // crossAxisAlignment: CrossAxisAlignment.center,
//                                                   // mainAxisAlignment:
//                                                   //     MainAxisAlignment.spaceBetween,
//                                                   children: [
//                                                     value.showToken == 1
//                                                         ? Container(
//                                                             alignment: Alignment
//                                                                 .topLeft,
//                                                             width: size.width *
//                                                                 0.12,
//                                                             child: Text(
//                                                               value.queuetList
//                                                                           .length <=
//                                                                       index
//                                                                   ? ""
//                                                                   : value.queuetList[
//                                                                           index]
//                                                                       [
//                                                                       "queue_token"],
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                               // tokenList[index].tokenNum.toString(),
//                                                               style: GoogleFonts
//                                                                   .aBeeZee(
//                                                                 textStyle: Theme.of(
//                                                                         context)
//                                                                     .textTheme
//                                                                     .bodyText2,
//                                                                 fontSize: value
//                                                                     .fontsize,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                                 color: value.queuetList.length >
//                                                                             index &&
//                                                                         value
//                                                                             .quelistReady &&
//                                                                         value.selectedTile[
//                                                                             index]
//                                                                     ? Colors
//                                                                         .white
//                                                                     : index % 2 ==
//                                                                             0
//                                                                         ? Colors
//                                                                             .white
//                                                                         : parseColor(
//                                                                             value.settings[0]["theme_clr"].toString(),
//                                                                           ),
//                                                               ),
//                                                             ),
//                                                           )
//                                                         : Container(),
//                                                     Container(
//                                                       width: value.showToken ==
//                                                               1
//                                                           ? size.width * 0.68
//                                                           : size.width * 0.2,
//                                                       alignment:
//                                                           Alignment.topLeft,
//                                                       child: Text(
//                                                         textAlign:
//                                                             TextAlign.start,
//                                                         value.queuetList
//                                                                     .length <=
//                                                                 index
//                                                             ? ""
//                                                             : value.queuetList[
//                                                                     index][
//                                                                     "queue_token"]
//                                                                 .toString()
//                                                                 .toUpperCase(),
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         // tokenList[index].name.toString(),
//                                                         style:
//                                                             GoogleFonts.aBeeZee(
//                                                           textStyle:
//                                                               Theme.of(context)
//                                                                   .textTheme
//                                                                   .bodyText2,
//                                                           fontSize:
//                                                               value.fontsize,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: value.queuetList
//                                                                           .length >
//                                                                       index &&
//                                                                   value
//                                                                       .quelistReady &&
//                                                                   value.selectedTile[
//                                                                       index]
//                                                               ? Colors.white
//                                                               : index % 2 == 0
//                                                                   ? Colors.white
//                                                                   : parseColor(
//                                                                       value
//                                                                           .settings[
//                                                                               0]
//                                                                               [
//                                                                               "theme_clr"]
//                                                                           .toString(),
//                                                                     ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Container(
//                                                       width: size.width * 0.15,
//                                                       alignment:
//                                                           Alignment.topLeft,
//                                                       child: Text(
//                                                         value.queuetList
//                                                                     .length <=
//                                                                 index
//                                                             ? ""
//                                                             : value.queuetList[
//                                                                     index]
//                                                                     ["cab_id"]
//                                                                 .toString()
//                                                                 .toUpperCase(),
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style:
//                                                             GoogleFonts.aBeeZee(
//                                                           textStyle:
//                                                               Theme.of(context)
//                                                                   .textTheme
//                                                                   .bodyText2,
//                                                           fontSize:
//                                                               value.fontsize,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: value.queuetList
//                                                                           .length >
//                                                                       index &&
//                                                                   value
//                                                                       .quelistReady &&
//                                                                   value.selectedTile[
//                                                                       index]
//                                                               ? Colors.white
//                                                               : index % 2 == 0
//                                                                   ? Colors.white
//                                                                   : parseColor(
//                                                                       value
//                                                                           .settings[
//                                                                               0]
//                                                                               [
//                                                                               "theme_clr"]
//                                                                           .toString(),
//                                                                     ),
//                                                         ),
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                           ],
//                         );
//                       }
//                     },
//                   ),
//                 ),
//                 // Container(
//                 //   width: 200,
//                 //   child: LayoutBuilder(
//                 //     builder: (context, constraints) {
//                 //       if (kIsWeb && constraints.maxWidth > 750) {
//                 //         return Row(
//                 //           crossAxisAlignment: CrossAxisAlignment.start,
//                 //           children: [
//                 //             // Expanded(
//                 //             //   flex: 3,
//                 //             //   child: Column(
//                 //             //     children: [
//                 //             //       player,
//                 //             //       const VideoPositionIndicator(),
//                 //             //     ],
//                 //             //   ),
//                 //             // ),
//                 //             const Expanded(
//                 //               flex: 2,
//                 //               child: SingleChildScrollView(
//                 //                 child: Controls(),
//                 //               ),
//                 //             ),
//                 //           ],
//                 //         );
//                 //       }

//                 //       return ListView(
//                 //         children: [
//                 //           player,
//                 //           const VideoPositionIndicator(),
//                 //           const Controls(),
//                 //         ],
//                 //       );
//                 //     },
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future _setAwaitOptions() async {
//     await flutterTts.awaitSpeakCompletion(true);
//   }

//   void initSetting(String lang) async {
//     await flutterTts.setVolume(volume);
//     await flutterTts.setPitch(pitch);
//     await flutterTts.setSpeechRate(speechrate);

//     await flutterTts.setLanguage(langCode!);
//     // flutterTts.getVoices();
//   }

//   void _speak(String text, String start, int i, String lang) async {
//     initSetting(lang);

//     if (start != "init") {
//       Provider.of<Controller>(context, listen: false).setColor(i, true);

//       print(
//           "zdsd----${Provider.of<Controller>(context, listen: false).selectedTile}");
//     }

//     await flutterTts.speak(text);
//   }

//   void getQueueList() async {
//     String str = "";
//     Timer.periodic(Duration(seconds: 7), (timer) {
//       // Provider.of<Controller>(context, listen: false).setColor(i, false);

//       if (Provider.of<Controller>(context, listen: false).quelistReady) {
//         if (i <
//             Provider.of<Controller>(context, listen: false).queuetList.length) {
//           selectedTile = selectedTile + 1;

//           // Provider.of<Controller>(context, listen: false).setColor(i);
//           print(
//               "dszdszds---${Provider.of<Controller>(context, listen: false).queuetList[i]["msg"]}-------${Provider.of<Controller>(context, listen: false).queuetList[i]["voice_status"].runtimeType}");
//           if (Provider.of<Controller>(context, listen: false).queuetList[i]
//                   ["voice_status"] ==
//               "0") {
//             _speak(
//                 Provider.of<Controller>(context, listen: false).queuetList[i]
//                     ["msg"],
//                 "speak",
//                 i,
//                 "en");
//             // _speak(
//             // Provider.of<Controller>(context, listen: false).queuetList[i]
//             //     ["msg"],
//             // "speak",
//             // i,"ar");
//           }

//           updateList.add(Provider.of<Controller>(context, listen: false)
//               .queuetList[i]["queue_id"]);
//           // Future.delayed(const Duration(milliseconds: 500), () {
//           //   Provider.of<Controller>(context, listen: false)
//           //       .getQueueList(context, i);
//           // });

//           // Provider.of<Controller>(context, listen: false).setColor(i, false);

//           i = i + 1;

//           // });
//         } else {
//           str = updateList.join(",");
//           print("str-----$str");

//           Provider.of<Controller>(context, listen: false)
//               .updateList(context, str);
//           Provider.of<Controller>(context, listen: false)
//               .getQueueList(context, i);
//           updateList.clear();
//           i = 0;
//           selectedTile = 0;
//           // _start--;
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.close();
//     timer!.cancel();
//     super.dispose();
//   }
// }

// ///
// class Controls extends StatelessWidget {
//   ///
//   const Controls();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // MetaDataSection(),
//           // _space,
//           // SourceInputSection(),
//           // _space,
//           // PlayPauseButtonBar(),
//           // _space,
//           // const VideoPositionSeeker(),
//           // _space,
//           // PlayerStateSection(),
//         ],
//       ),
//     );
//   }

//   Widget get _space => const SizedBox(height: 10);
// }

// ///
// class VideoPlaylistIconButton extends StatelessWidget {
//   ///
//   const VideoPlaylistIconButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.ytController;

//     return IconButton(
//       onPressed: () async {
//         controller.pauseVideo();
//         // await Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (context) => const VideoListPage(),
//         //   ),
//         // );
//         controller.playVideo();
//       },
//       icon: const Icon(Icons.playlist_play_sharp),
//     );
//   }
// }

// ///
// class VideoPositionIndicator extends StatelessWidget {
//   ///
//   const VideoPositionIndicator({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.ytController;

//     return StreamBuilder<YoutubeVideoState>(
//       stream: controller.videoStateStream,
//       initialData: const YoutubeVideoState(),
//       builder: (context, snapshot) {
//         final position = snapshot.data?.position.inMilliseconds ?? 0;
//         final duration = controller.metadata.duration.inMilliseconds;

//         return LinearProgressIndicator(
//           value: duration == 0 ? 0 : position / duration,
//           minHeight: 1,
//         );
//       },
//     );
//   }
// }

// ///
// class VideoPositionSeeker extends StatelessWidget {
//   ///
//   const VideoPositionSeeker({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var value = 0.0;

//     return Row(
//       children: [
//         const Text(
//           'Seek',
//           style: TextStyle(fontWeight: FontWeight.w300),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: StreamBuilder<YoutubeVideoState>(
//             stream: context.ytController.videoStateStream,
//             initialData: const YoutubeVideoState(),
//             builder: (context, snapshot) {
//               final position = snapshot.data?.position.inSeconds ?? 0;
//               final duration = context.ytController.metadata.duration.inSeconds;

//               value = position == 0 || duration == 0 ? 0 : position / duration;

//               return StatefulBuilder(
//                 builder: (context, setState) {
//                   return Slider(
//                     value: value,
//                     onChanged: (positionFraction) {
//                       value = positionFraction;
//                       setState(() {});

//                       context.ytController.seekTo(
//                         seconds: (value * duration).toDouble(),
//                         allowSeekAhead: true,
//                       );
//                     },
//                     min: 0,
//                     max: 1,
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//   //////////////////////////////////////////////////////////////
// }
