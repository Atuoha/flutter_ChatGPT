import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/open_ai_completion.dart';

class MessageBubble extends StatelessWidget {
    MessageBubble({
    Key? key,
    required this.imgUrl,
    required this.size,
    required this.text,
    required this.isUser,
    required this.copyResponse,
    required this.toggleIsLiked,
    required this.editText,
    this.completionId = '',
  }) : super(key: key);

  final Size size;
  final String text;
  final String imgUrl;
  final bool isUser;
  final Function copyResponse;
  final Function toggleIsLiked;
  final Function editText;
  String completionId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isUser ? primaryColor : accentColor,
      padding: const EdgeInsets.symmetric(vertical:20),
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
        title: Text(
          text.trim(),
          style: const TextStyle(
            color: Colors.white,
            height: 1.5,
          ),
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
                      onTap: () =>  toggleIsLiked(completion: completionId, value:true),
                      child: const Icon(
                        Icons.thumb_up_outlined,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),

                    // dislike
                    GestureDetector(
                      onTap: () => toggleIsLiked(completion: completionId, value:false),
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
