import 'package:flutter/material.dart';
import 'package:vitacare/components/message.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vitacare/utils/aifunctions.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  _AIChatPageState createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;
  bool _isListening = false;

  final stt.SpeechToText _speech = stt.SpeechToText();

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _clearMessageController() {
    _controller.clear();
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords; 
        });
        if (result.finalResult) {
          _stopListening();
          callGeminiModel(_controller, _messages, _setLoading, _clearMessageController);
        }
      });
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: screenHeight * 0.1,
        title: Row(
          children: [
            Image.asset(
              'assets/icons/VitaCare.png',
              height: screenHeight * 0.05,
              width: screenHeight * 0.05,
            ),
            SizedBox(width: screenWidth * 0.03),
            Text(
              'Vita AI',
              style: TextStyle(
                color: Colors.black87,
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Colors.blueAccent.withOpacity(0.9)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(message.isUser ? 20 : 0),
                        bottomRight: Radius.circular(message.isUser ? 0 : 20),
                      ),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black87,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // User Input Section
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: screenWidth * 0.03,
                    offset: Offset(0, screenHeight * 0.005),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: screenWidth * 0.04,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02,
                        ),
                      ),
                    ),
                  ),
                  _isLoading
                      ? Padding(
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          child: SizedBox(
                            width: screenWidth * 0.05,
                            height: screenWidth * 0.05,
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent.withOpacity(0.5),
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Row(
  children: [
    GestureDetector(
      onTap: () async {
        if (!_isListening) {
          await _startListening();
        } else {
          await _stopListening();
        }
      },
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            boxShadow: _isListening
                ? [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.5),
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : [],
          ),
          child: Icon(
            _isListening ? Icons.mic_sharp: Icons.mic,
            color: Colors.blueAccent,
            size: screenWidth * 0.06,
          ),
        ),
      ),
    ),
    GestureDetector(
      onTap: () {
        callGeminiModel(
          _controller,
          _messages,
          _setLoading,
          _clearMessageController,
        );
      },
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Icon(
          Icons.send,
          color: Colors.blueAccent,
          size: screenWidth * 0.06,
        ),
      ),
    ),
  ],
),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
