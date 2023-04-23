import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/authentication/repository/auth_service.dart';
import 'package:vooms/chat/chat_repository/chat_service.dart';
import 'package:vooms/chat/chat_repository/chat_service_impl.dart';
import 'package:vooms/chat/entities/conversation.dart';
import 'package:vooms/chat/entities/message.dart';
import 'package:vooms/dependency.dart';
import 'package:vooms/shareds/components/m_cached_image.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

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
                      return BuildMessageRow(
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

class BottomMessageInput extends StatelessWidget {
  final TextEditingController senderTextField;
  final void Function() onPressed;
  const BottomMessageInput(
      {super.key, required this.senderTextField, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: UIColorConstant.primaryGreen, width: 2),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10.0),
          Expanded(
            child: TextField(
              controller: senderTextField,
              decoration: const InputDecoration(
                hintText: 'Type a message',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(bottom: 10),
            icon: const Icon(
              Icons.send_rounded,
              color: UIColorConstant.primaryBlue,
            ),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class BuildMessageRow extends StatelessWidget {
  const BuildMessageRow({
    super.key,
    required this.senderId,
    required this.message,
  });

  final String senderId;
  final Message message;

  @override
  Widget build(BuildContext context) {
    bool isMe = message.senderId == senderId;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          isMe ? 0 : MediaQuery.of(context).size.width / 2,
          5,
          isMe ? MediaQuery.of(context).size.width / 2 : 0,
          5),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isMe
                          ? UIColorConstant.materialPrimaryRed
                          : UIColorConstant.primaryGreen),
                  child: Text(
                    message.content,
                    style: GoogleFonts.dmMono(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  message.timestamp.toTime(),
                  style: GoogleFonts.dmMono(
                      fontWeight: FontWeight.w300,
                      color: UIColorConstant.nativeGrey,
                      fontSize: 11),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AppBarChat extends StatelessWidget {
  final TutorEntity entity;
  final Conversation? conversation;
  const AppBarChat({super.key, required this.entity, this.conversation});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 38,
            )),
        McachedImage(
          url: entity.photoUrl,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entity.fullname,
              style: GoogleFonts.dmMono(fontWeight: FontWeight.bold),
            ),
            Text(
              conversation == null
                  ? "...."
                  : "last Seen ${conversation?.memberDetail.first.lastSeen.toTime()}",
              style: GoogleFonts.dmMono(color: UIColorConstant.nativeGrey),
            ),
          ],
        )
      ],
    );
  }
}
