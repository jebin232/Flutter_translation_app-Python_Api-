import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart'; // Import Flutter services for accessing clipboard
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TranslateScreen2 extends StatefulWidget {
  @override
  _TranslateScreenState createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen2> {
  final TextEditingController _textEditingController = TextEditingController();
  String _translatedText = '';
  String _orignal = '';
  FlutterTts flutterTts = FlutterTts();
  bool _isLoading = false;

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initializeSpeechToText();
  }

  Future<void> _initializeSpeechToText() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  Future<void> _startListening() async {
    if (_speechEnabled) {
      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords;
          });
          _translateText(_lastWords); // Translate recognized text
        },
      );
    }
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
  }

  Future<void> _translateText(String text) async {
    _orignal = text;
    if (text.isNotEmpty) {
      setState(() {
        _isLoading = true; // Show loader
      });
      try {
        final response = await http.post(
          Uri.parse('https://translation-python-api.onrender.com/german'),
          headers: {
            'Content-Type': 'application/json', // Set content type to JSON
          },
          body: jsonEncode({'text': text}), // Encode the body as JSON
        );
        if (response.statusCode == 200) {
          setState(() {
            _translatedText = json.decode(response.body)['translated_text'];
          });
        } else {
          throw Exception(
              'Failed to translate text. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false; // Hide loader
        });
      }
    }
  }

  void _copyTranslatedText() {
    Clipboard.setData(ClipboardData(text: _translatedText));
  }

  Future<void> _speakTranslatedText() async {
    if (_translatedText.isNotEmpty) {
      await flutterTts.setLanguage('de-DE');
      await flutterTts.speak(_translatedText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translate To German'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    labelText: 'Enter text to translate',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _translateText(_textEditingController.text),
                  child: Text('Translate'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _speakTranslatedText,
                  child: Text('Speak Translated Text'),
                ),
                SizedBox(height: 20),
                Text(
                  'Translated Text:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Text(
                              _orignal,
                              textAlign: TextAlign.justify,
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Text(
                              _translatedText,
                              textAlign: TextAlign.justify,
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      // If listening is active show the recognized words
                      _speechToText.isListening
                          ? '$_lastWords'
                          // If listening isn't active but could be tell the user
                          // how to start it, otherwise indicate that speech
                          // recognition is not yet ready or not supported on
                          // the target device
                          : _speechEnabled
                              ? 'Tap the microphone to start listening...'
                              : 'Speech not available',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    _speechToText.stop();
    super.dispose();
  }
}
