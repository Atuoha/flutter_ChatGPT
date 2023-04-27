import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/constants/colors.dart';
import 'package:flutter_chatgpt/resources/string_manager.dart';

import '../resources/assets_manager.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 18,
    );

    return Scaffold(
      body: Container(
        color: primaryColor,
        constraints: const BoxConstraints.expand(),
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
                  onPressed: ()=> null,
                  child: Text('Login'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: btnBg),
                  onPressed: ()=> null,
                  child: Text('Signup'),
                )
              ]
            )
          ],

        ),
      ),
    );
  }
}
