import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/chat/chat_repository/chat_service_impl.dart';
import 'package:vooms/chat/entities/conversation.dart';
import 'package:vooms/shareds/components/m_cached_image.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

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
