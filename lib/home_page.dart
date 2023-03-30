import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jarvis/colors.dart';
import 'package:jarvis/openai_service.dart';
import 'package:jarvis/suggestion_box.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final fluttertts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> initTextToSpeech() async {
    await fluttertts.setSharedInstance(true);
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await fluttertts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    fluttertts.stop();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var hour = now.hour;
    String greeting = '';

    if (hour >= 7 && hour < 12) {
      greeting = 'Good morning';
    } else if (hour >= 12 && hour < 15) {
      greeting = 'Good Afternoon';
    } else if (hour >= 16 && hour < 22) {
      greeting = 'Good evening';
    } else {
      greeting = 'Hello';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("JARVIS,YOUR AI ASSISTANT"),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // image
            Stack(
              children: [
                Center(
                    child: Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle),
                )),
                Container(
                  height: 125,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/images/image.png'))),
                )
              ],
            ),

            // chat area
            Visibility(
              visible: generatedImageUrl == null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 40)
                    .copyWith(top: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: Pallete.borderColor),
                    borderRadius: BorderRadius.circular(20)
                        .copyWith(topLeft: Radius.zero)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    generatedContent == null
                        ? '$greeting, how can I help you? '
                        : generatedContent!,
                    style: TextStyle(
                        color: Pallete.mainFontColor,
                        fontSize: generatedContent == null ? 20 : 16,
                        fontFamily: 'Cera Pro'),
                  ),
                ),
              ),
            ),

            if (generatedImageUrl != null) Image.network(generatedImageUrl!),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 5, left: 5),
                child: const Text(
                  'Here are a few commands for you',
                  style: TextStyle(
                      fontFamily: "Cera Pro",
                      color: Pallete.mainFontColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Suggestions
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: const [
                  SuggestionBox(
                    color: Pallete.firstSuggestionBoxColor,
                    headerText: "ChatGPT",
                    desc:
                        "A better way to organize and be informed with Open AI's ChatGPT",
                  ),
                  SuggestionBox(
                    color: Pallete.secondSuggestionBoxColor,
                    headerText: "Dall-E",
                    desc:
                        "An AI system that can create realistic images and art from a description in natural language.",
                  ),
                  SuggestionBox(
                    color: Pallete.thirdSuggestionBoxColor,
                    headerText: "Smart Voice Assitant",
                    desc: "Same text",
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            final speech = await openAIService.isArtPromptAPI(lastWords);
            if (speech.contains('https')) {
              generatedImageUrl = speech;
              generatedContent = null;
              setState(() {});
            } else {
              generatedImageUrl = null;
              generatedContent = speech;
              setState(() {});
              await systemSpeak(speech);
            }
            await systemSpeak(speech);
            print(speech);
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
      ),
    );
  }
}
