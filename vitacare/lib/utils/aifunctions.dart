import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vitacare/components/message.dart';

Future<void> callGeminiModel(
  TextEditingController messageController,
  List<Message> messages,
  Function(bool) setLoading,
  Function() clearMessageController,
) async {
  try {
    if (messageController.text.isNotEmpty) {
      setLoading(true);
      messages.add(Message(text: messageController.text, isUser: true)); 
    }
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: "AIzaSyCntOUJ55NKZ-_yx-DGAS9Z2MD6Dfgrac8",
    );
    final prompt = messageController.text.trim();
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    String vitatext = response.text!
        .replaceAll("Google", "Tech-Codianzz")
        .replaceAll("Gemini", "Vita");

    messages.add(Message(text: vitatext, isUser: false));
    setLoading(false);
    clearMessageController();
  // ignore: empty_catches
  } catch (e) {
  }
}
