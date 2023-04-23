import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/chat/chat_repository/chat_service.dart';
import 'package:vooms/chat/components/app_bar_chat.dart';
import 'package:vooms/chat/components/bottom_message_input.dart';
import 'package:vooms/chat/components/message_row.dart';
import 'package:vooms/chat/entities/conversation.dart';
import 'package:vooms/chat/entities/message.dart';
import 'package:vooms/dependency.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key, required this.recepientEntity});
  final TutorEntity recepientEntity;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final TextEditingController _senderTextField;
  late final ScrollController _scrollController;
  List<Message> _messages = [];
  Conversation? _conversation;
  String _senderId = '';
  StreamSubscription<List<Message>>? _streamMessageSubscription;
  StreamSubscription<Conversation?>? _streamConversationSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _senderTextField = TextEditingController();
    _listenMessage();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMessageInput(
        senderTextField: _senderTextField,
        onPressed: _sendMessage,
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppBarChat(
              entity: widget.recepientEntity,
              conversation: _conversation,
            ),
            if (_isLoading)
              const CircularProgressIndicator()
            else 
              Flexible(
                child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return MessageRow(
                          senderId: _senderId, message: _messages[index]);
                    }),
              ),
          ],
        ),
      ),
    );
  }

  void _defaultToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

 void _listenMessage() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final currentUser = await sl<ChatService>().currentUser();

      if (currentUser != null) {
        _senderId = currentUser.uid;
      }

      await sl<ChatService>().createMember(
          '', 'user', [_senderId, widget.recepientEntity.id], _senderId);

      _streamMessageSubscription = sl<ChatService>()
          .getMessagesByConversationIds(
              [_senderId, widget.recepientEntity.id]).listen((event) {
        setState(() {
          _messages = event;
        });
        // Wait for the _messages list to be initialized before scrolling to the bottom.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _defaultToBottom();
        });
      }, onError: (error) {
        debugPrint('Error fetching messages: $error');
      });

      _streamConversationSubscription = sl<ChatService>().getConversationById(
          [_senderId, widget.recepientEntity.id]).listen((event) {
        setState(() {
          _conversation = event;
        });
      }, onError: (error) {
        debugPrint('Error fetching conversation: $error');
      });
    } catch (error) {
      debugPrint('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _sendMessage() async {
    try {
      if (_senderTextField.text.isEmpty) {
        return;
      }

      sl<ChatService>().sendMessage(
        [_senderId, widget.recepientEntity.id],
        _senderId,
        _senderTextField.text,
      );

      setState(() {
        _senderTextField.clear();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _dispose() {
    if (_streamMessageSubscription != null) {
      _streamMessageSubscription?.cancel();
    }
    if (_streamConversationSubscription != null) {
      _streamConversationSubscription?.cancel();
    }
    _senderTextField.clear();
    _senderTextField.dispose();
  }
}

