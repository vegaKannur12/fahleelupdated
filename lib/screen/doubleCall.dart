import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DoubleCall extends StatefulWidget {
  const DoubleCall({super.key});

  @override
  State<DoubleCall> createState() => _DoubleCallState();
}

class _DoubleCallState extends State<DoubleCall> {
  List list = [1, 2];
  FlutterTts flutterTts = FlutterTts();
  double pitch = 1.0;
  String? langCode = "en-IN";
  double volume = 1.0;

  double speechrate = 0.5;
  List<String> languages = [];
  @override
  void dispose() {
    // _controller!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: ElevatedButton(
              onPressed: () async {
                // _speak("welcome to city clinic");
                Future.forEach(
                    list,
                    (ITEM_IN_LIST) =>
                        new Future.delayed(new Duration(seconds: 2), () {
                          /// YOUR FUNCTION for speak

                          _speak("welcome to city clinic");
                        }).then(print)).then(print).catchError(print);

                // runTextToSpeech("welcome to city clinic", 0.5);
              },
              child: Text("click")),
        ),
      ),
    );
  }

  Future<void> runTextToSpeech(
      String currentTtsString, double currentSpeechRate) async {
    FlutterTts flutterTts;
    flutterTts = new FlutterTts();
    await flutterTts.awaitSpeakCompletion(false);
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.isLanguageAvailable("en-IN");
    await flutterTts.setSpeechRate(currentSpeechRate);
    await flutterTts.speak(currentTtsString);
  }

  void initSetting() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(speechrate);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage(langCode!);
    // flutterTts.getVoices();
  }

  void _speak(String text) async {
    initSetting();

    await flutterTts.speak(text);
  }
}
