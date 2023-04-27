import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/constants/colors.dart';
import 'package:flutter_chatgpt/resources/assets_manager.dart';

import '../constants/text_field_enum.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key, required this.isSignIn}) : super(key: key);
  final bool isSignIn;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool isSignIn = true;
  bool isPasswordObscured = true;

  @override
  void initState() {
    passwordController.addListener(() {
      setState(() {});
    });
    setState(() {
      isSignIn = widget.isSignIn;
    });
    super.initState();
  }

  // textfield
  Widget kTextField({
    required TextEditingController controller,
    required TextFieldEnum textFieldEnum,
    required String hintText,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      autofocus: textFieldEnum == TextFieldEnum.email ? true : false,
      obscureText:
          textFieldEnum == TextFieldEnum.email ? false : isPasswordObscured,
      validator: (value) {
        if (value!.isEmpty) {
          return '$label can not be empty';
        }
        switch (textFieldEnum) {
          case TextFieldEnum.email:
            if (!value.contains('@') || value.length < 5) {
              return 'Email needs to be valid';
            }
            break;

          case TextFieldEnum.password:
            if (value.length < 8) {
              return 'Password needs to be valid';
            }
            break;
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: textFieldEnum == TextFieldEnum.password
            ? passwordController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () => setState(() {
                      isPasswordObscured = !isPasswordObscured;
                    }),
                    child: Icon(
                        isPasswordObscured
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: btnBg),
                  )
                : const SizedBox.shrink()
            : const SizedBox.shrink(),
        hintText: hintText,
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade500,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade500,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          right: 18.0,
          left: 18.0,
          top: MediaQuery.of(context).padding.top,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AssetManager.logo2, width: 150),
              const SizedBox(height: 50),
              Text(
                isSignIn ? 'Welcome back' : 'Create your account',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    kTextField(
                      controller: emailController,
                      textFieldEnum: TextFieldEnum.email,
                      hintText: 'johndoe@gmail.com',
                      label: 'Email Address',
                    ),
                    const SizedBox(height: 10),
                    kTextField(
                      controller: passwordController,
                      textFieldEnum: TextFieldEnum.password,
                      hintText: '********',
                      label: 'Password',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnBg,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 15,
                        ),
                      ),
                      onPressed: () => null,
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Wrap(
                        children: [
                          Text(
                            isSignIn
                                ? 'Already have an account?'
                                : 'Don\'t have an account?',
                            style: const TextStyle(color: primaryColor),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () => setState(() {
                              isSignIn = !isSignIn;
                            }),
                            child: Text(
                              isSignIn ? 'Log in' : 'Sign up',
                              style: const TextStyle(color: btnBg),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                      ),
                      onPressed: () => null,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,

                        children: [
                          Image.asset(AssetManager.googleImage, width: 30,),
                          const SizedBox(width: 10),
                          const Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 18,
                            color:Colors.grey
                          ),
                        ),
                        ]
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
