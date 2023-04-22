import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/authentication/repository/auth_service.dart';
import 'package:vooms/chat/chat_repository/chat_service.dart';
import 'package:vooms/chat/chat_repository/chat_service_impl.dart';
import 'package:vooms/chat/entities/member.dart';
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
  Member? _member;
  String _senderId = '';
  StreamSubscription<List<Message>>? _streamMessageSubscription;
  StreamSubscription<Member>? _streamMemberSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _senderTextField = TextEditingController();
    _listenMessage();
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

      _streamMessageSubscription = sl<ChatService>().getMessagesByMemberIds(
          [_senderId, widget.recepientEntity.id]).listen((event) {
        setState(() {
          _messages = event;
        });
        // Wait for the _messages list to be initialized before scrolling to the bottom.
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _defaultToBottom();
        });
      });

      _streamMemberSubscription = sl<ChatService>().getMemberById(
          [_senderId, widget.recepientEntity.id]).listen((event) {
        setState(() {
          _member = event;
        });
      });
    } catch (error) {
      debugPrint(error.toString());
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

  @override
  void dispose() {
    if (_streamMessageSubscription != null) {
      _streamMessageSubscription?.cancel();
    }
    if (_streamMemberSubscription != null) {
      _streamMemberSubscription?.cancel();
    }
    _senderTextField.clear();
    _senderTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _isLoading
                ? const CircularProgressIndicator()
                : Flexible(
                    child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageRow(index);
                        }),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
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
    );
  }

  Widget _buildHeader() {
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
          url: widget.recepientEntity.photoUrl,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.recepientEntity.fullname,
              style: GoogleFonts.dmMono(fontWeight: FontWeight.bold),
            ),
            Text(
             _member == null ? "...." : "last Seen ${_member?.memberDetail.first.lastSeen.toTime()}",
              style: GoogleFonts.dmMono(color: UIColorConstant.nativeGrey),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildMessageRow(int index) {
    bool isMe = _messages[index].senderId == _senderId;
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
                    _messages[index].content,
                    style: GoogleFonts.dmMono(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  _messages[index].timestamp.toTime(),
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
