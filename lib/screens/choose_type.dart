import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt/constants/colors.dart';
import 'package:flutter_chatgpt/resources/string_manager.dart';
import '../business_logic/open_ai_model/open_ai_model_cubit.dart';
import '../resources/assets_manager.dart';
import 'chat_screen.dart';

class ChooseTypeScreen extends StatelessWidget {
  const ChooseTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // navigate to completion
    void navigateToCompletion() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ChatScreen(isChatMode: false),
        ),
      );
      context.read<OpenAiModelCubit>().setModel('text-davinci-003'); // set model
    }

    // navigate to chat screen
    void navigateToChat() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ChatScreen(isChatMode: true),
        ),
      );
      context.read<OpenAiModelCubit>().setModel('gpt-3.5-turbo'); // set model
    }

    // style for text
    TextStyle style = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 18,
    );

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AssetManager.logoWhite, width: 100),
          const SizedBox(height: 10),
          Text(StringManager.chooseTypeText, style: style),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnBg,
                ),
                onPressed: () => navigateToChat(),
                child: const Text('Chat'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnBg,
                ),
                onPressed: () => navigateToCompletion(),
                child: const Text('Completion'),
              )
            ],
          )
        ],
      ),
    );
  }
}
