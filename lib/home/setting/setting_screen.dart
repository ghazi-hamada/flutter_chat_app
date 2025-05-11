import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/home/setting/profile_screen.dart';
import 'package:flutter_chat_app/home/setting/qr_code_screen.dart';
import 'package:flutter_chat_app/main.dart';
import 'package:flutter_chat_app/theme/theme_color_cubit.dart';
import 'package:flutter_chat_app/theme/theme_cubit.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:iconsax/iconsax.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              minVerticalPadding: 40,
              leading: CircleAvatar(
                radius: 40,
                backgroundImage: CachedNetworkImageProvider(
                  FirebaseAuth.instance.currentUser!.photoURL.toString(),
                ),
              ),
              title: Text(
                FirebaseAuth.instance.currentUser!.displayName.toString(),
              ),
              subtitle: Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
              ),
              trailing: IconButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QrCodeScreen()),
                    ),
                icon: Icon(Iconsax.scan_barcode),
              ),
            ),
            Card(
              child: ListTile(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    ),
                leading: const Icon(Iconsax.user),
                title: const Text('Profile'),
              ),
            ),
            Card(
              child: ListTile(
                onTap:
                    () => showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor:
                                    context.read<ThemeColorCubit>().state,
                                onColorChanged: (value) {
                                  context.read<ThemeColorCubit>().changeColor(
                                    value,
                                  );
                                  Navigator.pop(context); // إغلاق بعد الاختيار
                                },
                              ),
                            ),
                          ),
                    ),
                leading: Icon(Iconsax.color_swatch),
                title: Text('Theme'),
                trailing: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: context.watch<ThemeColorCubit>().state,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Iconsax.moon),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: context.watch<ThemeCubit>().state == ThemeMode.dark,
                  onChanged: (value) {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                    (route) => false,
                  );
                },

                trailing: Icon(Iconsax.logout),
                title: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
