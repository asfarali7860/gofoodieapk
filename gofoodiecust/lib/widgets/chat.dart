// // ignore_for_file: avoid_print, deprecated_member_use

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gofoodie/widgets/appbar_widget.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:sound_stream/sound_stream.dart';
// import 'package:dialogflow_grpc/dialogflow_grpc.dart';
// import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2beta1/session.pb.dart';

// late DialogflowGrpcV2Beta1 dialogflow;

// class Chat extends StatefulWidget {
//   const Chat({Key? key}) : super(key: key);

//   @override
//   _ChatState createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   final List<ChatMessage> _messages = <ChatMessage>[];
//   final TextEditingController _textController = TextEditingController();

//   bool _isRecording = false;

//   final RecorderStream _recorder = RecorderStream();
//   StreamSubscription<List<int>>? _audioStreamSubscription;
//   StreamSubscription? _recorderStatus;
//   BehaviorSubject<List<int>>? _audioStream;

//   @override
//   void initState() {
//     super.initState();
//     initPlugin();
//   }

//   @override
//   void dispose() {
//     _recorderStatus?.cancel();
//     _audioStreamSubscription?.cancel();
//     super.dispose();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlugin() async {
//     _recorderStatus = _recorder.status.listen((status) {
//       if (mounted) {
//         setState(() {
//           _isRecording = status == SoundStreamStatus.Playing;
//         });
//       }
//     });

//     await Future.wait([_recorder.initialize()]);

//     final serviceAccount = ServiceAccount.fromString(
//         (await rootBundle.loadString('assets/credentials.json')));

//     dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);
//   }

//   void stopStream() async {
//     await _recorder.stop();
//     await _audioStreamSubscription?.cancel();
//     await _audioStream?.close();
//   }

//   void handleSubmitted(text) async {
//     print(text);
//     _textController.clear();

//     ChatMessage message = ChatMessage(
//       text: text,
//       name: "You",
//       type: true,
//     );

//     setState(() {
//       _messages.insert(0, message);
//     });

//     DetectIntentResponse data = await dialogflow.detectIntent(text, 'en-US');
//     String fulfillmentText = data.queryResult.fulfillmentText;
//     if (fulfillmentText.isNotEmpty) {
//       ChatMessage botMessage = ChatMessage(
//         text: fulfillmentText,
//         name: "Bot",
//         type: false,
//       );

//       setState(() {
//         _messages.insert(0, botMessage);
//       });
//     }
//   }

//   void handleStream() async {
//     _recorder.start();

//     _audioStream = BehaviorSubject<List<int>>();
//     _audioStreamSubscription = _recorder.audioStream.listen((data) {
//       print(data);
//       _audioStream?.add(data);
//     });

//     var biasList = SpeechContextV2Beta1(phrases: [
//       'Dialogflow CX',
//       'Dialogflow Essentials',
//       'Action Builder',
//       'HIPAA'
//     ], boost: 20.0);

//     var config = InputConfigV2beta1(
//         encoding: 'AUDIO_ENCODING_LINEAR_16',
//         languageCode: 'en-US',
//         sampleRateHertz: 16000,
//         singleUtterance: false,
//         speechContexts: [biasList]);

//     final responseStream =
//         dialogflow.streamingDetectIntent(config, _audioStream!);
//     responseStream.listen((data) {
//       setState(() {
//         String transcript = data.recognitionResult.transcript;
//         String queryText = data.queryResult.queryText;
//         String fulfillmentText = data.queryResult.fulfillmentText;

//         if (fulfillmentText.isNotEmpty) {
//           ChatMessage message = ChatMessage(
//             text: queryText,
//             name: "You",
//             type: true,
//           );

//           ChatMessage botMessage = ChatMessage(
//             text: fulfillmentText,
//             name: "Bot",
//             type: false,
//           );

//           _messages.insert(0, message);
//           _textController.clear();
//           _messages.insert(0, botMessage);
//         }
//         if (transcript.isNotEmpty) {
//           _textController.text = transcript;
//         }
//       });
//     }, onError: (e) {}, onDone: () {});
//   }

//   // The chat interface
//   //
//   //------------------------------------------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const TealBackButton(),
//       ),
//       body: Column(children: <Widget>[
//         Flexible(
//             child: ListView.builder(
//           padding: const EdgeInsets.all(8.0),
//           reverse: true,
//           itemBuilder: (_, int index) => _messages[index],
//           itemCount: _messages.length,
//         )),
//         const Divider(height: 1.0),
//         Container(
//             decoration: BoxDecoration(color: Theme.of(context).cardColor),
//             child: IconTheme(
//               data:
//                   IconThemeData(color: Theme.of(context).colorScheme.secondary),
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Row(
//                   children: <Widget>[
//                     Flexible(
//                       child: TextField(
//                         controller: _textController,
//                         onSubmitted: handleSubmitted,
//                         decoration: const InputDecoration.collapsed(
//                             hintText: "Send a message"),
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                       child: IconButton(
//                         icon: const Icon(Icons.send),
//                         onPressed: () => handleSubmitted(_textController.text),
//                       ),
//                     ),
//                     IconButton(
//                       iconSize: 30.0,
//                       icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
//                       onPressed: _isRecording ? stopStream : handleStream,
//                     ),
//                   ],
//                 ),
//               ),
//             )),
//       ]),
//     );
//   }
// }

// //------------------------------------------------------------------------------------
// // The chat message balloon
// //
// //------------------------------------------------------------------------------------
// class ChatMessage extends StatelessWidget {
//   const ChatMessage(
//       {Key? key, required this.text, required this.name, required this.type})
//       : super(key: key);

//   final String text;
//   final String name;
//   final bool type;

//   List<Widget> otherMessage(context) {
//     return <Widget>[
//       Container(
//         margin: const EdgeInsets.only(right: 16.0),
//         child: const CircleAvatar(child: Text('B')),
//       ),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//             Container(
//               margin: const EdgeInsets.only(top: 5.0),
//               child: Text(text),
//             ),
//           ],
//         ),
//       ),
//     ];
//   }

//   List<Widget> myMessage(context) {
//     return <Widget>[
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: <Widget>[
//             Text(name, style: Theme.of(context).textTheme.subtitle1),
//             Container(
//               margin: const EdgeInsets.only(top: 5.0),
//               child: Text(text),
//             ),
//           ],
//         ),
//       ),
//       Container(
//         margin: const EdgeInsets.only(left: 16.0),
//         child: CircleAvatar(
//             child: Text(
//           name[0],
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         )),
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: type ? myMessage(context) : otherMessage(context),
//       ),
//     );
//   }
// }
