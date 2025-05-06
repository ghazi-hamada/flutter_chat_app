import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/home/chat/chat_list_screen.dart';
import 'package:flutter_chat_app/home/contacts/contacts_screen.dart';
import 'package:flutter_chat_app/home/groups/groups_screen.dart';
import 'package:flutter_chat_app/home/setting/setting_screen.dart';
import 'package:flutter_chat_app/layout/layout_cubit/layout_cubit.dart';
import 'package:iconsax/iconsax.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

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
        return Scaffold(
          body: screens[context.read<LayoutCubit>().curuntIndex],
        
          bottomNavigationBar: NavigationBar(
            selectedIndex: context.read<LayoutCubit>().curuntIndex,
            onDestinationSelected:
                (value) => context.read<LayoutCubit>().changeIndex(value),
            destinations: [
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
