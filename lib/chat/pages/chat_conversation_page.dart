import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/activity/repository/tutor_repository.dart';
import 'package:vooms/chat/chat_repository/chat_service.dart';
import 'package:vooms/chat/chat_repository/chat_service_impl.dart';
import 'package:vooms/chat/entities/conversation.dart';
import 'package:vooms/chat/pages/chat_room_page.dart';
import 'package:vooms/dependency.dart';
import 'package:vooms/shareds/components/app_dialog.dart';
import 'package:vooms/shareds/components/m_cached_image.dart';
import 'package:vooms/shareds/general_helper/text_extension.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class ChatConversationPage extends StatefulWidget {
  const ChatConversationPage({super.key});

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  bool _isLoading = false;
  String _senderId = "";
  StreamSubscription<List<Conversation>>? _streamSubscription;
  List<Conversation> _conversations = [];
  List<TutorEntity> _tutors = [];

  void _getTutorInConversation() async {
    try {
      final either = await sl<TutorRepository>().getTutors();
      if (either.isLeft()) {
        throw "failure in download tutor detail";
      }
      if (either.isRight()) {
        either.map((r) => setState(() {
              _tutors = r;
            }));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _getConversations() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final data = await sl<ChatService>().currentUser();
      if (data != null) {
        _senderId = data.uid;
      }
      _streamSubscription = sl<ChatService>()
          .getAllConversationByUserId(_senderId)
          .listen((event) {
        setState(() {
          _conversations = event;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getConversations();
    _getTutorInConversation();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: UIColorConstant.nativeWhite,
        title: const Text("Chats").toNormalText(fontSize: 18),
      ),
      body: SafeArea(
          child: (_isLoading)
              ? const CircularProgressIndicator()
              : ConversationsList(
                  conversations: _conversations,
                  senderId: _senderId,
                  tutorEntities: _tutors)),
    );
  }
}

class ConversationsList extends StatelessWidget {
  final List<Conversation> conversations;
  final List<TutorEntity> tutorEntities;
  final String senderId;
  const ConversationsList(
      {super.key,
      required this.conversations,
      required this.senderId,
      required this.tutorEntities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          var conversation = conversations[index];
          var recentMessage = conversation.recentMessage;
          var recepientData = conversation.memberDetail
              .firstWhere((element) => element.userId != senderId);
          var listTile = const ListTile();
          final tutorEntity = _getTutorEntity(recepientData.userId);
          final userAvatarImage = tutorEntity != null
              ? McachedImage(url: tutorEntity.photoUrl)
              : Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: UIColorConstant.primaryBlue,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Text(recepientData.displayName[0].toUpperCase(),
                        style: GoogleFonts.dmMono(
                          color: UIColorConstant.nativeWhite,
                        )),
                  ));
          if (recentMessage != null) {
            listTile = ListTile(
              onTap: (){
                _onTap(tutorEntity, context);
              },
              leading: userAvatarImage,
              title: Text(
                recepientData.displayName,
                style: GoogleFonts.dmMono(),
              ),
              subtitle:
                  Text(recentMessage.message, style: GoogleFonts.dmMono()),
              trailing: Text(
                recentMessage.sendAt.toTime(),
                style: GoogleFonts.dmMono(),
              ),
            );
          }

          return listTile;
        });
  }

  TutorEntity? _getTutorEntity(String recepientId) {
    if (tutorEntities.isNotEmpty) {
      try {
        return tutorEntities.singleWhere(
          (element) => element.id == recepientId,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  void _onTap(TutorEntity? tutorEntity, BuildContext context) {
    if (tutorEntity != null) {
      var route = CupertinoPageRoute(
          builder: ((context) => ChatRoomPage(
                recepientEntity: tutorEntity,
              )));
      Navigator.push(context, route);
    } else {
      AppDialog.snackBarModal(context,
          message: "Failed to get the tutor detail");
    }
  }
}
