import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vooms/authentication/repository/auth_service.dart';
import 'package:vooms/chat/chat_repository/chat_service.dart';
import 'package:vooms/chat/entities/message.dart';
import 'package:vooms/dependency.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key, required this.recipientId});
  final String recipientId;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final StreamController<List<Message>> _messageController;
  late final StreamSubscription<List<Message>> _streamSubscription;
  late final TextEditingController _senderTextField;
  String? conversId;
  List<Message> messages = [];

  @override
  void initState() {
     // Initialize the TextEditingController
    _senderTextField = TextEditingController();
    // Initialize the StreamController
    _messageController = StreamController<List<Message>>(); 
    // Use Future.microtask to perform an asynchronous operation after the widget is built
    Future.microtask(() async { 
      // Get the current user from the AuthService
      final model = await sl<AuthService>().currentUser; 
      if (model != null) {
        // Get the conversation ID from the ChatService
        conversId = await sl<ChatService>()
            .getConversationId(model.uid, widget.recipientId); 
        if (conversId != null) {
          // Listen to the stream of messages and add each message to the StreamController
          _streamSubscription = sl<ChatService>()
              .getMessagesForConversation(conversId!)
              .listen((event) { 
            _messageController.add(event);
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _messageController.close();
    _senderTextField.clear();
    _senderTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10.0),
            Expanded(
              child: TextField(
                controller: _senderTextField,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                final model = await sl<AuthService>().currentUser;
                if (_senderTextField.text.isNotEmpty &&
                    conversId != null &&
                    model != null) {
                  sl<ChatService>().sendMessage(
                      conversId!, model.uid, _senderTextField.text);
                  setState(() {
                    _senderTextField.clear();
                  });
                }
              },
            ),
            const SizedBox(width: 10.0),
          ],
        ),
      ),
      body: StreamBuilder<List<Message>>(
        stream: _messageController.stream,
        initialData: const [],
        builder: (context, data) {
          return ListView.builder(
              itemCount: data.data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data.data![index].content),
                );
              });
        },
      ),
    );
  }
}
