import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/firebase/fire_database.dart';
import 'package:flutter_chat_app/home/chat/chat_screen.dart';
import 'package:flutter_chat_app/home/contacts/contacts_cubit/contacts_cubit.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:iconsax/iconsax.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactsCubit, ContactsState>(
      listener: (context, state) {
        if (state is ContactsCreated) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(Iconsax.user_add),
            onPressed: () {
              showBottomSheet(
                context: context,
                builder:
                    (context) => Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text('Enter Friend Email'),
                              Spacer(),
                              IconButton.filled(
                                onPressed: () {},
                                icon: Icon(Iconsax.scan_barcode),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Form(
                            key: context.read<ContactsCubit>().formKey,
                            child: TextFormField(
                              controller:
                                  context.read<ContactsCubit>().emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Iconsax.direct),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter an email';
                                } else if (value ==
                                    FirebaseAuth.instance.currentUser!.email)
                                  return 'You can not add yourself';
                                return null;
                              },
                            ),
                          ),

                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                            ),
                            child: const Text('create chat'),
                            onPressed: () {
                              context.read<ContactsCubit>().createContacts();
                            },
                          ),
                        ],
                      ),
                    ),
              );
            },
          ),
          appBar: AppBar(
            title:
                context.read<ContactsCubit>().isSearch
                    ? TextField(
                      autofocus: true,
                      onChanged: (value) {
                        context.read<ContactsCubit>().whenSearching();
                      },
                      controller:
                          context.read<ContactsCubit>().searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: const Icon(Iconsax.search_normal_1),
                      ),
                    )
                    : const Text('Contacts'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  context.read<ContactsCubit>().isSearch
                      ? Iconsax.close_square
                      : Iconsax.search_normal_1,
                  size: !context.read<ContactsCubit>().isSearch ? 24 : 32,
                ),
                onPressed: () {
                  context.read<ContactsCubit>().changeSearch();
                },
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final myContacts = snapshot.data!.data()!['my_contacts'];
                    return StreamBuilder(
                      stream:
                          FirebaseFirestore.instance
                              .collection('users')
                              .where('id', whereIn: myContacts)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        List<ChatUser> users =
                            snapshot.data!.docs
                                .map((e) => ChatUser.fromJson(e.data()))
                                .where(
                                  (e) => e.name!.toLowerCase().startsWith(
                                    context
                                        .read<ContactsCubit>()
                                        .searchController
                                        .text
                                        .toLowerCase(),
                                  ),
                                )
                                .toList()
                              ..sort((e1, e2) => e1.name!.compareTo(e2.name!));
                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return ContactCard(users: users[index]);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.users});

  final ChatUser users;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(users.image.toString()),
        ),
        title: Text(users.name!),
        subtitle: Text(users.email!),
        trailing: IconButton(
          onPressed: () {
            List<String> usersId = [
              users.id!,
              FirebaseAuth.instance.currentUser!.uid,
            ]..sort((e1, e2) => e1.compareTo(e2));
            FireDatabase().createRoom(email: users.email!).then((value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          ChatScreen(roomId: usersId.toString(), user: users),
                ),
              );
            });
          },
          icon: Icon(Iconsax.message),
        ),
      ),
    );
  }
}
