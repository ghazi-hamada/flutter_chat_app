import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/home/contacts/contacts_cubit/contacts_cubit.dart';
import 'package:iconsax/iconsax.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(Iconsax.message_add),
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
                          TextFormField(
                            controller: TextEditingController(),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Iconsax.direct),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty ? 'Enter an email' : null,
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
                              // context.read<ChatListCubit>().sendInvitation();
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
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Card(
                      child: const ListTile(
                        leading: CircleAvatar(),
                        title: Text('User Name'),
                        subtitle: Text('User Email'),
                        trailing: Icon(Iconsax.message),
                      ),
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
