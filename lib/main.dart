import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt/repositories/repos.dart';
import 'package:flutter_chatgpt/screens/entry.dart';
import 'constants/colors.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'business_logic/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();
  runApp(const ChatGptApp());
}

class ChatGptApp extends StatelessWidget {
  const ChatGptApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: primaryColor,
      ),
    );
    return MultiRepositoryProvider(
      providers: [
        // auth repository
        RepositoryProvider(
          create: (context) => AuthRepository(
            firebaseAuth: FirebaseAuth.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),

        // profile repository
        RepositoryProvider(
          create: (context) => ProfileRepository(
            firebaseAuth: FirebaseAuth.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // auth bloc
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),

          // sign in cubit
          BlocProvider(
            create: (context) => GoogleAuthCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),

          // sign up cubit
          BlocProvider(
            create: (context) => SignInCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),

          // google auth cubit
          BlocProvider(
            create: (context) => SignUpCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),

          // profile cubit
          BlocProvider(
            create: (context) => ProfileCubit(
              profileRepository: context.read<ProfileRepository>(),
            ),
          ),

          // api_work cubit
          BlocProvider(
            create: (context) => OpenAiModelCubit(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            appBarTheme: const AppBarTheme(color: primaryColor),
          ),
          debugShowCheckedModeBanner: false,
          home: const AppEntry(),
        ),
      ),
    );
  }
}
