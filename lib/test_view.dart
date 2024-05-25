import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TestView extends StatefulWidget {
  const TestView({Key? key}) : super(key: key);

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  String words = '';
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('words: $words'),
              Container(
                child: ElevatedButton(
                    onPressed: _button, child: const Text('start Listening')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _button() async {
    stt.SpeechToText speech = stt.SpeechToText();
    bool available = await speech.initialize(onStatus: (str) {
      debugPrint(str);
    }, onError: (e) {
      debugPrint('Error$e');
    });
    if (available) {
      debugPrint("The user has allowed the use of speech recognition.");

      speech.listen(
          pauseFor: const Duration(seconds: 2),
          listenFor: const Duration(seconds: 10),
          onSoundLevelChange: (level) {
            debugPrint('level: $level');
            if (level < 0.3 && level > -0.3) {
              debugPrint('is quiet around');
            }
          },
          onResult: ((result) {
            words = result.recognizedWords;
            debugPrint('words: ${result.recognizedWords}');
            setState(() {});
          }));
    } else {
      debugPrint("The user has denied the use of speech recognition.");
    }
    // some time later...
    // debugPrint('stopping');
    // speech.stop();
  }
}
