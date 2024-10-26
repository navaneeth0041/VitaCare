import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vitacare/providers/vitaprovider.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; 
import 'package:flutter_tts/flutter_tts.dart'; 

class SpeechService {
  late stt.SpeechToText _speechToText;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _isAwaitingCommand = false;
  Timer? _silenceTimer;
  String _commandBuffer = '';

  SpeechService(Ref ref) {
    _speechToText = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initSpeech(ref);
  }

void _initSpeech(Ref ref) async {
  await _speechToText.initialize(
    onStatus: (status) {
      print('Speech Status: $status');
      if (status == 'notListening' && !_isAwaitingCommand) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!_isListening) _startListening(ref);
        });
      }
    },
    onError: (error) {
      print('Error: $error');
      if (error.permanent) {
        _stopListening(ref, restart: false);
      } else {
        _stopListening(ref, restart: true);
      }
    },
  );

  _flutterTts.setCompletionHandler(() {
    print("TTS completed, calling _resetAfterTTS.");
    _resetAfterTTS(ref); 
  });

  _startListening(ref); 
}

  void _startListening(Ref ref) async {
    if (_isListening) return;
    _isListening = true;

    await _speechToText.listen(
      onResult: (result) {
        if (result.recognizedWords.contains("hello") && !_isAwaitingCommand) {
          print('Wake command detected!');
          ref.read(vitaDetectionProvider.notifier).state = true;
          _isAwaitingCommand = true;
          _commandBuffer = '';
          _resetSilenceTimer(ref);

          _stopListening(ref, restart: false); 
          Future.delayed(const Duration(milliseconds: 500), () {
            _startListeningForCommand(ref);
          });
        }
      },
      listenFor: const Duration(seconds: 10),
    );
  }

  void _startListeningForCommand(Ref ref) async {
    if (_isListening) return;
    _isListening = true;

    await _speechToText.listen(
      onResult: (result) {
        if (_isAwaitingCommand) {
          _commandBuffer += result.recognizedWords + ' ';
          print('Current command buffer: $_commandBuffer');
          _resetSilenceTimer(ref);
        }
      },
      listenFor: const Duration(seconds: 10),
    );
  }

  void _resetSilenceTimer(Ref ref) {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(seconds: 8), () async {
      print('Stopping glowing indicator after silence.');
      ref.read(vitaDetectionProvider.notifier).state = false;
      _isAwaitingCommand = false;
      print('Final command received: $_commandBuffer');
      await _callGeminiModel(_commandBuffer, ref);
    });
  }

  Future<void> _callGeminiModel(String prompt, Ref ref) async {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: "AIzaSyCntOUJ55NKZ-_yx-DGAS9Z2MD6Dfgrac8",
    );
    final response = await model.generateContent([Content.text(prompt)]);

    String responseText = response.text!
        .replaceAll("Google", "Tech-Codianzz")
        .replaceAll("Gemini", "Vita");

    print('Response: $responseText');
    await _flutterTts.speak(responseText); 
  }

  void _stopListening(Ref ref, {bool restart = true}) async {
    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
      if (restart) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _startListening(ref);
        });
      }
    }
  }
void _resetAfterTTS(Ref ref) {
  print("TTS playback complete, resetting states...");

  _isAwaitingCommand = false;
  _commandBuffer = '';
  ref.read(vitaDetectionProvider.notifier).state = false;

  _isListening = false;
  _startListening(ref);
}

}

final speechServiceProvider = Provider<SpeechService>((ref) {
  return SpeechService(ref);
});
