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
  late final StreamSubscription<List<Message>> _streamSubscription;
  late final TextEditingController _senderTextField;
  String? _conversationId;
  List<Message> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    _senderTextField = TextEditingController();
    Future.microtask(() async {
      try {
        // Get the current user from the AuthService
        final currentUser = await sl<AuthService>().currentUser;
        if (currentUser == null) {
          throw 'User not found';
        }

        // Get the conversation ID from the ChatService
        final conversationId = await sl<ChatService>()
            .getConversationId(currentUser.uid, widget.recipientId);

        if (conversationId == null) {
          throw 'Conversation not found';
        }

        _conversationId = conversationId;
        // Listen to the stream of messages and add each message to the StreamController
        _streamSubscription = sl<ChatService>()
            .getMessagesForConversation(conversationId)
            .listen((messages) {
          setState(() {
            _messages = messages;
            _isLoading = false;
          });
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        debugPrint(error.toString());
      }
    });
  }

  void _sendMessage() async {
    if (_senderTextField.text.isEmpty || _conversationId == null) {
      return;
    }

    final currentUser = await sl<AuthService>().currentUser;
    if (currentUser == null) {
      return;
    }

    sl<ChatService>().sendMessage(
      _conversationId!,
      currentUser.uid,
      _senderTextField.text,
    );

    setState(() {
      _senderTextField.clear();
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
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
            IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
            const SizedBox(width: 10.0),
          ],
        ),
      ),
      body: _isLoading
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index].content),
                );
              }),
    );
  }
}
