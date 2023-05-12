import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    Key? key,
    required this.textController,
    required this.size,
    required this.generateResponse,
    required this.isTyping,
  }) : super(key: key);
  final Size size;
  final TextEditingController textController;
  final Function generateResponse;
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: msgBg,
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            offset: Offset(0, 3),
            blurRadius: 3,
            spreadRadius: 3,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),

      // height: size.height / 15,
      child: TextField(
        maxLines: null,
        controller: textController,
        textInputAction: TextInputAction.done,
        onSubmitted: (value)=>isTyping ? null :generateResponse(),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Send a message',
          hintStyle: const TextStyle(color: hintColor),
          suffixIcon: GestureDetector(
            onTap: () => isTyping ? null : generateResponse(),
            child: const Icon(
              Icons.send,
              color: hintColor,
            ),
          ),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
