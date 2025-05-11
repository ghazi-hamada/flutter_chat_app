import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/core/services/fcm_services.dart';
import 'package:flutter_chat_app/firebase/fire_auth.dart';
import 'package:flutter_chat_app/home/chat/chat_cubit/chat_cubit.dart';
import 'package:flutter_chat_app/home/chat/chat_list_cubit/chat_list_cubit.dart';
import 'package:flutter_chat_app/home/chat/chat_list_screen.dart';
import 'package:flutter_chat_app/auth/forget_password/forget_password_cubit/forget_password_cubit.dart';
import 'package:flutter_chat_app/home/contacts/contacts_cubit/contacts_cubit.dart';
import 'package:flutter_chat_app/home/groups/create_group/create_group_cubit.dart';
import 'package:flutter_chat_app/home/groups/edit_group/edit_group_cubit.dart';
import 'package:flutter_chat_app/home/groups/groups_cubit/groups_cubit.dart';
import 'package:flutter_chat_app/home/setting/setting_cubit/setting_cubit.dart';
import 'package:flutter_chat_app/layout/layout_cubit/layout_cubit.dart';
import 'package:flutter_chat_app/layout/layout_screen.dart';
import 'package:flutter_chat_app/auth/login/login_cubit/login_cubit.dart';
import 'package:flutter_chat_app/auth/login/login_screen.dart';
import 'package:flutter_chat_app/auth/singup/signuup_cubit/signup_cubit.dart';
import 'package:flutter_chat_app/theme/theme_color_cubit.dart';
import 'package:flutter_chat_app/theme/theme_cubit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   WidgetsFlutterBinding.ensureInitialized();

  /// 1.1.2: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // call the useSystemCallingUI
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
  });
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
        BlocProvider(create: (context) => GroupsCubit()),
        BlocProvider(create: (context) => CreateGroupCubit()),
        BlocProvider(create: (context) => EditGroupCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (_) => ThemeColorCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<ThemeColorCubit, Color>(
            builder: (context, primaryColor) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                themeMode: themeMode,
                darkTheme: ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: primaryColor,
                    brightness: Brightness.dark,
                  ),
                ),
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
                  useMaterial3: true,
                ),
                
                home: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                       if (FireAuth.user != null) {
      FireAuth().updateActivatedTime(false);
  }
                        FcmService.init();
                      return LayoutScreen(); // Navigate to ChatScreen if logged in
                    } else {
                      return LoginScreen(); // Navigate to LoginScreen if not logged in
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
