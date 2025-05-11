import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/core/bottom_sheet.dart';
import 'package:flutter_chat_app/home/setting/setting_cubit/setting_cubit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          context.read<SettingCubit>().setControllers(
            about: snapshot.data!['abuot'],
            name: snapshot.data!['name'],
          );
          return BlocConsumer<SettingCubit, SettingState>(
            listener: (context, state) {
              if (state is SettingSuccess) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        BlocBuilder<SettingCubit, SettingState>(
                          builder: (context, state) {
                            return CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  context.read<SettingCubit>().image == null
                                      ? snapshot.data!['image'] == ''
                                          ? null
                                          : NetworkImage(
                                            snapshot.data!['image'],
                                          )
                                      : FileImage(
                                        context.watch<SettingCubit>().image!,
                                      ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: IconButton.filled(
                            onPressed: () {
                              showCameraOrGallerySheet(
                                context,
                                onCameraSelected: () async {
                                  await context
                                      .read<SettingCubit>()
                                      .chooseImage(isGallery: false);
                                },
                                onGallerySelected: () async {
                                  await context
                                      .read<SettingCubit>()
                                      .chooseImage(isGallery: true);
                                },
                              );
                            },
                            icon: Icon(Iconsax.gallery_edit),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Card(
                      child: ListTile(
                        leading: const Icon(Iconsax.user),
                        title: const Text('Name'),
                        subtitle:
                            context.read<SettingCubit>().isEditingName
                                ? TextFormField(
                                  controller:
                                      context
                                          .read<SettingCubit>()
                                          .nameController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                )
                                : Text(snapshot.data!['name']),
                        trailing: IconButton(
                          icon: Icon(Iconsax.edit),
                          onPressed: () {
                            context.read<SettingCubit>().nameController.text =
                                snapshot.data!['name'];
                            context.read<SettingCubit>().toggleEditName();
                          },
                        ),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: const Icon(Iconsax.info_circle),
                        title: const Text('About'),
                        subtitle:
                            context.read<SettingCubit>().isEditingAbout
                                ? TextFormField(
                                  controller:
                                      context
                                          .read<SettingCubit>()
                                          .aboutController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                )
                                : Text(snapshot.data!['abuot']),
                        trailing: IconButton(
                          icon: Icon(Iconsax.edit),
                          onPressed: () {
                            context.read<SettingCubit>().aboutController.text =
                                snapshot.data!['abuot'];
                            context.read<SettingCubit>().toggleEditAbout();
                          },
                        ),
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: const Icon(Iconsax.direct),
                        title: const Text('Email'),
                        subtitle: Text(snapshot.data!['email']),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Iconsax.calendar),
                        title: const Text('Joined at'),
                        subtitle: Text(
                          '${DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!['create_at'])))} ',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
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
                        onPressed: () {
                          context.read<SettingCubit>().updateProfile();
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
