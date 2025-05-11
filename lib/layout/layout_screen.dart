import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/home/chat/chat_list_screen.dart';
import 'package:flutter_chat_app/home/contacts/contacts_screen.dart';
import 'package:flutter_chat_app/home/groups/groups_screen.dart';
import 'package:flutter_chat_app/home/setting/setting_screen.dart';
import 'package:flutter_chat_app/layout/layout_cubit/layout_cubit.dart';
import 'package:iconsax/iconsax.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      ChatList(),
      GroupsScreen(),
      ContactsScreen(),
      SettingScreen(),
    ];

    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        final layoutCubit = context.read<LayoutCubit>();

        return Scaffold(
          body: screens[layoutCubit.curuntIndex],

          bottomNavigationBar: NavigationBar(
            selectedIndex: layoutCubit.curuntIndex,
            onDestinationSelected: (value) => layoutCubit.changeIndex(value),
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.message), label: 'Chat'),
              NavigationDestination(
                icon: Icon(Iconsax.messages),
                label: 'Groups',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.user),
                label: 'Contacts',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.setting),
                label: 'Setting',
              ),
            ],
          ),
        );
      },
    );
  }
}
