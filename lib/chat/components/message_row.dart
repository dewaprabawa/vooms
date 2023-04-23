import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/chat/chat_repository/chat_service_impl.dart';
import 'package:vooms/chat/entities/message.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class MessageRow extends StatelessWidget {
  const MessageRow({
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