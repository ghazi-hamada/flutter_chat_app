import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/home/chat/chat_cubit/chat_cubit.dart';
import 'package:flutter_chat_app/home/chat/chat_list_cubit/chat_list_cubit.dart';
import 'package:flutter_chat_app/home/chat/chat_list_screen.dart';
import 'package:flutter_chat_app/auth/forget_password/forget_password_cubit/forget_password_cubit.dart';
import 'package:flutter_chat_app/home/contacts/contacts_cubit/contacts_cubit.dart';
import 'package:flutter_chat_app/home/setting/setting_cubit/setting_cubit.dart';
import 'package:flutter_chat_app/layout/layout_cubit/layout_cubit.dart';
import 'package:flutter_chat_app/layout/layout_screen.dart';
import 'package:flutter_chat_app/auth/login/login_cubit/login_cubit.dart';
import 'package:flutter_chat_app/auth/login/login_screen.dart';
import 'package:flutter_chat_app/auth/singup/signuup_cubit/signup_cubit.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => SignupCubit()),
        BlocProvider(create: (context) => ForgetPasswordCubit()),
        BlocProvider(create: (context) => ChatListCubit()),
        BlocProvider(create: (context) => LayoutCubit()),
        BlocProvider(create: (context) => ContactsCubit()),
        BlocProvider(create: (context) => SettingCubit()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.dark,
          ),
        ),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlue,

            brightness: Brightness.light,
          ),
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return LayoutScreen(); // Navigate to ChatScreen if logged in
            } else {
              return LoginScreen(); // Navigate to LoginScreen if not logged in
            }
          },
        ),
      ),
    );
  }
}
