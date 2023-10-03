import 'package:flutter/material.dart';

import '../model/MessagesModel.dart';
import '../model/UserModel.dart';

class MessageThreadScreen extends StatelessWidget {
  final MessageModel message;
  final UserModel receiver;

  MessageThreadScreen({required this.message, required this.receiver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message Thread"),
      ),
      body: Column(
        children: [
          // Display the message here
          Text(message.text),
          // Add a text input and send button for continuing the conversation
          // ...
        ],
      ),
    );
  }
}
