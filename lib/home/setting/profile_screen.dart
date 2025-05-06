import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(radius: 50),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Iconsax.user),
                title: const Text('Name'),
                subtitle: const Text('Ghazi Hamada'),
                trailing: const Icon(Iconsax.edit),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Iconsax.info_circle),
                title: const Text('About'),
                subtitle: const Text('I am a Flutter developer'),
                trailing: const Icon(Iconsax.edit),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Iconsax.direct),
                title: const Text('Email'),
                subtitle: const Text('mKl6H@example.com'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Iconsax.calendar),
                title: const Text('Joined at'),
                subtitle: const Text('2023-01-01'),
              ),
            ),
            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                onPressed: () {},
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
