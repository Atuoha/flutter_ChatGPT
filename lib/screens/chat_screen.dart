import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt/components/text_loading.dart';
import 'package:flutter_chatgpt/components/text_box.dart';
import '../business_logic/auth_bloc/auth_bloc.dart';
import '../business_logic/profile/profile_cubit.dart';
import '../components/container_bg.dart';
import '../components/loading_widget.dart';
import '../components/msg_snackbar.dart';
import '../constants/colors.dart';
import '../constants/enums/process_status.dart';
import '../constants/enums/status.dart';
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
  bool isLoading = false;
  User user = User.initial(); // setting user to initial (empty)
  final userId = fbauth.FirebaseAuth.instance.currentUser!.uid; // user id



  // fetch user data
  Future<void> fetchUserData() async {
    await context.read<ProfileCubit>().getProfile(userId: userId);
    setState(() {
      user = context.read<ProfileCubit>().state.user;
    });
  }

  // init State
  @override
  void initState() {
    fetchUserData();
    super.initState();
  }


  // generate response from OpenAI
  void generateResponse() {
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
      isLoading = true;
    });
    print(textController.text);
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
        title: Row(
          children: const [
            Icon(Icons.logout,color: Colors.white,),
            SizedBox(width: 10),
            Text(
            'Do you want to log out?',
            style: TextStyle(color: Colors.white),
          ),
          ]
        ),
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
                  color: Colors.white
              ),
            ),
            const SizedBox(height: 2),
            Text(user.email,style: const TextStyle(color: Colors.white,fontSize: 14),),
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetManager.logo),
        ),
        title: const Text(
          StringManager.appName,
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state.status == ProcessStatus.loading) {
                const LoadingWidget(size: 10);
              }
            },
            child: GestureDetector(
              onTap: () => logOutHandle(),
              child: CircleAvatar(
                backgroundColor: btnBg,
                backgroundImage: NetworkImage(
                  user.profileImg ?? AssetManager.avatarUrl,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => signOut(),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [

        ],
      ),
      bottomSheet: ContainerBg(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading ? const TextLoading() : const SizedBox.shrink(),
            TextBox(
              textController: textController,
              size: size,
              generateResponse: generateResponse,
            )
          ],
        ),
      ),
    );
  }
}
