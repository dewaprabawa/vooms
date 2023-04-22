import 'dart:async';

import 'package:flutter/material.dart';


class ChatConversationPage extends StatefulWidget {
  const ChatConversationPage({super.key});

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  bool _isLoading = false;
  String _errorMessage = "";
  late final StreamSubscription _streamSubscription;

  // Future<void> _getConversationUser() async {
  //   print("Hello world");
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     final data = await sl<ChatService>().currentUser();
  //     if (data == null) {
  //       throw "the user not found";
  //     }
  //     _streamSubscription =
  //         sl<ChatService>().getParticipantByUser(data.uid).listen((event) {
  //       setState(() {
  //         print(event.length);
  //         _conversations = event;
  //         _isLoading = false;
  //       });
  //     });
  //   } catch (e) {
  //     debugPrint("THIS ERROR $e");
  //     setState(() {
  //       _errorMessage = "the conversation could not loaded because an error.";
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await _getConversationUser();
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container()
      ),
    );
  }
}
