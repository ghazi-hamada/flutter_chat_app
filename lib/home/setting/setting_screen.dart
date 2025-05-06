import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/home/setting/profile_screen.dart';
import 'package:flutter_chat_app/home/setting/qr_code_screen.dart';
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
              leading: CircleAvatar(radius: 30),
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
                              TextButton(
                                child: const Text('Save'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: Colors.red,
                                onColorChanged: (value) {},
                              ),
                            ),
                          ),
                    ),
                leading: Icon(Iconsax.color_swatch),
                title: Text('Theme'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Iconsax.moon),
                title: Text('Dark Mode'),
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () async => await FirebaseAuth.instance.signOut(),
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
