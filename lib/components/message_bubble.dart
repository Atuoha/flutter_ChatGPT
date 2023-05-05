import 'package:flutter/material.dart';
import '../constants/colors.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.imgUrl,
    required this.size,
    required this.text,
    required this.isUser,
    required this.copyResponse,
    required this.toggleIsLiked,
    required this.editText
  }) : super(key: key);

  final Size size;
  final String text;
  final String imgUrl;
  final bool isUser;
  final Function copyResponse;
  final Function toggleIsLiked;
  final Function editText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isUser ? primaryColor : accentColor,
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
          text,
          textAlign: TextAlign.justify,
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
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),

                    // like
                    GestureDetector(
                      onTap: () =>  toggleIsLiked(completion: '', value:true),
                      child: const Icon(
                        Icons.thumb_up_outlined,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),

                    // dislike
                    GestureDetector(
                      onTap: () => toggleIsLiked(completion: '', value:false),
                      child: const Icon(
                        Icons.thumb_down_outlined,
                        size: 15,
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
