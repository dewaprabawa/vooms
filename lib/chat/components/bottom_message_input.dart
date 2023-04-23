import 'package:flutter/material.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

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

