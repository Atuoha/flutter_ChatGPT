import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt/business_logic/export.dart';
import 'package:flutter_chatgpt/components/text_loading.dart';
import 'package:flutter_chatgpt/components/message_box.dart';
import 'package:flutter_chatgpt/models/exports.dart';
import 'package:flutter_chatgpt/repositories/api_repository.dart';
import '../components/container_bg.dart';
import '../components/dropdown_field.dart';
import '../components/loading_widget.dart';
import '../components/message_bubble.dart';
import '../components/msg_snackbar.dart';
import '../constants/colors.dart';
import '../constants/enums/status.dart';
import '../resources/assets_manager.dart';
import '../resources/string_manager.dart';
import 'entry.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.isChatMode,
  }) : super(key: key);
  final bool isChatMode;

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
    super.initState();
    fetchUserData();
    if (kDebugMode) {
      print('Mode: ${widget.isChatMode}');
      print('Model: ${context.read<OpenAiModelCubit>().state.selectedModel}');
    }
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

    List<OpenAICompletion> data = [];
    data.add(
      OpenAICompletion(
        id: DateTime.now().toString(),
        text: textController.text,
        isUser: true,
      ),
    );

    // set user data
    if (widget.isChatMode) {
      // set chats
      cxt.setChats(chats: data);
    } else {
      // set completions
      cxt.setCompletion(completions: data);
    }

    // response from API
    List<OpenAICompletion> response = [];
    try {
      if (widget.isChatMode) {
        response = await APIRepository.getChat(
          text: textController.text,
          model: context.read<OpenAiModelCubit>().state.selectedModel,
        );
      } else {
        response = await APIRepository.getCompletion(
          text: textController.text,
          model: context.read<OpenAiModelCubit>().state.selectedModel,
        );
      }

      // persist last sent text
      cxt.setCurrentMessage(textController.text);

      // set response from API
      if (widget.isChatMode) {
        // set chats
        cxt.setChats(chats: response);
      } else {
        // set completions
        cxt.setCompletion(completions: response);
      }

      setState(() {
        isCompletionDone = true;
        textController.clear();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      setState(() {
        isTyping = false;
      });
    }
  }

  // regenerate completion or chat
  void regenerateCompletion() async {
    setState(() {
      isTyping = true;
    });
    var cxt = context.read<OpenAiCompletionsCubit>(); // completion cubit

    List<OpenAICompletion> response = [];
    try {
      if (widget.isChatMode) {
        response = await APIRepository.getChat(
          text: cxt.state.currentMessage,
          model: context.read<OpenAiModelCubit>().state.selectedModel,
        );
      } else {
        response = await APIRepository.getCompletion(
          text: cxt.state.currentMessage,
          model: context.read<OpenAiModelCubit>().state.selectedModel,
        );
      }
      if (widget.isChatMode) {
        // set chats
        cxt.setChats(chats: response);
      } else {
        // set completions
        cxt.setCompletion(completions: response);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      setState(() {
        isTyping = false;
      });
    }
  }

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
      textController.text = text;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // show bottom modal
  Future<void> showBottomSheet() async {
    await showModalBottomSheet(
      backgroundColor: msgBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Selected Model:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            ModelDropDownButton(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var openAICubit = context.read<OpenAiCompletionsCubit>().state;

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
          widget.isChatMode
              ? const SizedBox.shrink()
              : IconButton(
                  onPressed: () => showBottomSheet(),
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ),
          SizedBox(width: widget.isChatMode ? 18 : 0),
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
              itemCount: widget.isChatMode
                  ? openAICubit.chats.length
                  : openAICubit.completions.length,
              itemBuilder: (context, index) {
                var completion = widget.isChatMode
                    ? openAICubit.chats[index]
                    : openAICubit.completions[index];
                return MessageBubble(
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
        ),
      ),
      bottomSheet: ContainerBg(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isTyping ? const TextLoading() : const SizedBox.shrink(),
            MessageBox(
              textController: textController,
              size: size,
              generateResponse: generateCompletion,
              isTyping: isTyping,
            )
          ],
        ),
      ),
    );
  }
}
