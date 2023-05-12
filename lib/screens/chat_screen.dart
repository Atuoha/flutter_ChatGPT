import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt/business_logic/export.dart';
import 'package:flutter_chatgpt/components/text_loading.dart';
import 'package:flutter_chatgpt/components/message_box.dart';
import 'package:flutter_chatgpt/repositories/api_repository.dart';
import '../components/container_bg.dart';
import '../components/loading_widget.dart';
import '../components/message_bubble.dart';
import '../components/msg_snackbar.dart';
import '../constants/colors.dart';
import '../constants/enums/status.dart';
import '../models/open_ai_completion.dart';
import '../models/user.dart';
import '../resources/assets_manager.dart';
import '../resources/string_manager.dart';
import 'entry.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textController = TextEditingController();
  bool isTyping = false;
  bool isProfileImgLoading = true;
  bool isCompletionDone = false; //
  User user = User.initial(); // setting user to initial (empty)
  final userId = fbauth.FirebaseAuth.instance.currentUser!.uid; // user id

  final model = 'gpt-3.5-turbo';

  // fetch user data
  Future<void> fetchUserData() async {
    await context.read<ProfileCubit>().getProfile(userId: userId);
    setState(() {
      user = context.read<ProfileCubit>().state.user;
      isProfileImgLoading = false;
    });
  }

  // init State
  @override
  void initState() {
    fetchUserData();
    context.read<OpenAiModelCubit>().selectModel(model);
    super.initState();
  }

  // sign out action
  void signOut() {
    context.read<AuthBloc>().add(SignOutEvent());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AppEntry(),
      ),
    );
  }

  // logout handle
  Future<void> logOutHandle() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: primaryColor,
        title: Row(children: const [
          Icon(
            Icons.logout,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Text(
            'Do you want to log out?',
            style: TextStyle(color: Colors.white),
          ),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                user.profileImg ?? AssetManager.avatarUrl,
              ),
              radius: 30,
            ),
            const SizedBox(height: 10),
            Text(
              user.username,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              user.email,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: btnBg,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => signOut(),
            child: const Text('Yes'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: btnBg,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  // generate response from OpenAI
  void generateCompletion() async {
    FocusScope.of(context).unfocus();
    if (textController.text.isEmpty) {
      displaySnackBar(
        status: Status.error,
        context: context,
        message: 'Text can not be empty',
      );
      return;
    }
    setState(() {
      isTyping = true;
    });
    var cxt = context.read<OpenAiCompletionsCubit>(); // completion cubit

    try {
      final chats = await APIRepository.getChat(
        text: textController.text,
        model: context.read<OpenAiModelCubit>().state.selectedModel,
      );

      // persist last sent text
      cxt.setCurrentMessage(textController.text);

      // persist completion
      cxt.setCurrentCompletion('');

      // set completions
      cxt.setChats(chats: chats);

      setState(() {
        isCompletionDone = true;
        textController.clear();
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isTyping = false;
      });
    }
  }

  // regenerate completion
  void regenerateCompletion() {}

  // copy response
  void copyResponse(String text) {
    Clipboard.setData(ClipboardData(text: text)).then(
      (_) => displaySnackBar(
        status: Status.success,
        message: 'Copied successfully',
        context: context,
      ),
    );
  }

  // toggleIsLike response
  void toggleIsLike({
    required String completionId,
    required bool value,
  }) {
    context.read<OpenAiCompletionsCubit>().toggleCompletionIsLike(
          completionId: completionId,
          value: value,
        );
  }

  // edit text
  void editText(String text) {
    setState(() {
      textController.text == text;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.asset(AssetManager.logo),
            ),
            const SizedBox(width: 10),
            const Text(
              StringManager.appName,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          isProfileImgLoading
              ? const LoadingWidget(size: 10)
              : GestureDetector(
                  onTap: () => logOutHandle(),
                  child: CircleAvatar(
                    backgroundColor: btnBg,
                    backgroundImage: NetworkImage(
                      user.profileImg.isEmpty
                          ? AssetManager.avatarUrl
                          : user.profileImg,
                    ),
                  ),
                ),
          const SizedBox(width: 18),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: isCompletionDone
          ? FloatingActionButton(
              onPressed: () => regenerateCompletion(),
              backgroundColor: accentColor,
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            )
          : const SizedBox.shrink(),
      extendBody: true,
      body: Padding(
          padding: const EdgeInsets.only(bottom: 70.0),
          child: SizedBox(
            height: size.height / 1,
            child: ListView.builder(
                itemCount: context
                    .read<OpenAiCompletionsCubit>()
                    .state
                    .chats
                    .length,
                itemBuilder: (context, index) {
                  var completion = context
                      .read<OpenAiCompletionsCubit>()
                      .state
                      .chats[index];
                  return
                      MessageBubble(
                        isUser: completion.isUser,
                        size: size,
                        text: completion.text,
                        imgUrl: completion.isUser
                            ? user.profileImg.isEmpty
                                ? AssetManager.avatarUrl
                                : user.profileImg
                            : AssetManager.logo,
                        toggleIsLiked: toggleIsLike,
                        copyResponse: copyResponse,
                        editText: editText,
                        completionId: completion.id,
                      );


                }),
          )),
      bottomSheet: ContainerBg(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isTyping ? const TextLoading() : const SizedBox.shrink(),
            MessageBox(
              textController: textController,
              size: size,
              generateResponse: generateCompletion,
            )
          ],
        ),
      ),
    );
  }
}
