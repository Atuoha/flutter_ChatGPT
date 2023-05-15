import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/models/exports.dart';
import '../constants/colors.dart';
import '../constants/enums/operation_type.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.imgUrl,
    required this.size,
    required this.text,
    required this.isUser,
    required this.copyResponse,
    required this.toggleIsLiked,
    required this.editText,
    required this.completionId,
    required this.isLiked,
    required this.operationType,
  }) : super(key: key);

  final Size size;
  final String text;
  final String imgUrl;
  final bool isUser;
  final Function copyResponse;
  final Function toggleIsLiked;
  final Function editText;
  final String completionId;
  final bool isLiked;
  final OperationType operationType;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isUser ? primaryColor : accentColor,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListTile(
        // contentPadding: EdgeInsets.all(5),
        leading: isUser
            ? CircleAvatar(
                backgroundColor: btnBg,
                backgroundImage: NetworkImage(imgUrl),
              )
            : CircleAvatar(
                backgroundColor: btnBg,
                backgroundImage: AssetImage(imgUrl),
              ),
        title: isUser
            ? Text(
                text.trim(),
                style: const TextStyle(
                  color: Colors.white,
                  height: 1.5,
                ),
              )
            : AnimatedTextKit(
          repeatForever: false,
                isRepeatingAnimation: false,
                displayFullTextOnTap: true,
                totalRepeatCount: 1,
                animatedTexts: [
                  TypewriterAnimatedText(

                    text.trim(),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
        trailing: SizedBox(
          width: size.width / 7,
          child: isUser
              // edit
              ? GestureDetector(
                  onTap: () => editText(text),
                  child: const Icon(
                    Icons.edit_note,
                    size: 18,
                    color: Colors.white,
                  ),
                )
              : Row(
                  children: [
                    // copy content
                    GestureDetector(
                      onTap: () => copyResponse(text),
                      child: const Icon(
                        Icons.content_paste,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),

                    // like
                    GestureDetector(
                      onTap: () => toggleIsLiked(
                        id: completionId,
                        value: true,
                        operationType: operationType,
                      ),
                      child: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),

                    // dislike
                    GestureDetector(
                      onTap: () => toggleIsLiked(
                        id: completionId,
                        value: false,
                        operationType: operationType,
                      ),
                      child: const Icon(
                        Icons.thumb_down_outlined,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
