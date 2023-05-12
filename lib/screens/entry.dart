import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt/constants/colors.dart';
import 'package:flutter_chatgpt/resources/string_manager.dart';
import 'package:flutter_chatgpt/screens/auth.dart';
import '../business_logic/auth_bloc/auth_bloc.dart';
import '../constants/enums/auth_status.dart';
import '../resources/assets_manager.dart';
import 'choose_type.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // navigate to auth screen
    void navigateToAuth({required bool isSignIn}) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AuthScreen(
            isSignIn: isSignIn,
          ),
        ),
      );
    }

    // navigate to chat screen
    void navigateToChat() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ChooseTypeScreen(),
        ),
      );
    }

    // style for text
    TextStyle style = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 18,
    );

    return Scaffold(
      backgroundColor: primaryColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.authStatus == AuthStatus.authenticated) {
            navigateToChat();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetManager.logoWhite, width: 100),
            const SizedBox(height: 10),
            Text(StringManager.welcomeText, style: style),
            const SizedBox(height: 10),
            Text(StringManager.logText, style: style),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: btnBg),
                  onPressed: () => navigateToAuth(isSignIn: true),
                  child: const Text('Login'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: btnBg),
                  onPressed: () => navigateToAuth(isSignIn: false),
                  child: const Text('Signup'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
