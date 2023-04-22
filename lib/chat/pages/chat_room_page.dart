import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/authentication/repository/auth_service.dart';
import 'package:vooms/chat/chat_repository/chat_service.dart';
import 'package:vooms/chat/chat_repository/chat_service_impl.dart';
import 'package:vooms/chat/entities/message.dart';
import 'package:vooms/dependency.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key, required this.entity});
  final TutorEntity entity;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final TextEditingController _senderTextField;
  ScrollController _scrollController = ScrollController();
  StreamSubscription<List<Message>>? _streamSubscription;
  List<Message> _messages = [];
  bool _isLoading = true;
  String _senderId = '';

  @override
  void initState() {
    super.initState();
    _senderTextField = TextEditingController();
    _listenMessage();
    // _scrollController = ScrollController(initialScrollOffset: double.infinity);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
       if(_isLoading == false){
        _scrollToBottom();
       }
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _listenMessage() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final currentUser = await sl<AuthService>().currentUser;
      if (currentUser == null) {
        throw 'User not found';
      }

      _senderId = currentUser.uid;

      await sl<ChatService>()
          .createMember("", "user", [_senderId, widget.entity.id], _senderId);

      _streamSubscription = sl<ChatService>().getMessagesByMemberIds(
          [_senderId, widget.entity.id]).listen((event) {
        setState(() {
          _messages = event;
          _isLoading = false;
        });
      });
    } catch (error) {
      debugPrint(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _sendMessage() async {
    try {
      if (_senderTextField.text.isEmpty) {
        return;
      }

      sl<ChatService>().sendMessage(
        [_senderId, widget.entity.id],
        _senderId,
        _senderTextField.text,
      );

      setState(() {
        _senderTextField.clear();
        _scrollToBottom();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    if (_streamSubscription != null) {
      _streamSubscription?.cancel();
    }
    _senderTextField.clear();
    _senderTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
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
                controller: _senderTextField,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: UIColorConstant.primaryBlue,
              ),
              onPressed: _sendMessage,
            ),
            const SizedBox(width: 10.0),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      size: 38,
                    )),
                CachedNetworkImage(
                  imageUrl: widget.entity.photoUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const Icon(Icons.image),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  widget.entity.fullname,
                  style: GoogleFonts.dmMono(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : Flexible(
                    child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          bool isMe = _messages[index].senderId == _senderId;
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                                isMe
                                    ? 0
                                    : MediaQuery.of(context).size.width / 2,
                                5,
                                isMe
                                    ? MediaQuery.of(context).size.width / 2
                                    : 0,
                                5),
                            child: Row(
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        //  width: MediaQuery.of(context).size.width/2,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: isMe
                                                ? UIColorConstant
                                                    .materialPrimaryRed
                                                : UIColorConstant.primaryGreen),
                                        child: Text(
                                          _messages[index].content,
                                          style: GoogleFonts.dmMono(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        _messages[index].timestamp.toTime(),
                                        style: GoogleFonts.dmMono(
                                            fontWeight: FontWeight.w300,
                                            color: UIColorConstant.nativeGrey),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  )
          ],
        ),
      ),
    );
  }
}
