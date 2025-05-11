import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/core/bottom_sheet.dart';
import 'package:flutter_chat_app/home/groups/edit_group/edit_group_cubit.dart';
import 'package:flutter_chat_app/models/chat_group_model.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:flutter_chat_app/widgets/custom_feild.dart';
import 'package:iconsax/iconsax.dart';

class EditGroup extends StatelessWidget {
  final ChatGroupModel chatGroupModel;
  const EditGroup({super.key, required this.chatGroupModel});

  @override
  Widget build(BuildContext context) {
    context.read<EditGroupCubit>().setData(
      chatGroupModel.name!,
      chatGroupModel.members!,
    );

    return BlocConsumer<EditGroupCubit, EditGroupState>(
      listener: (context, state) {
        if (state is EditGroupSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is EditGroupLoading) {
          Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.read<EditGroupCubit>().editGroup(chatGroupModel.id!);
            },
            icon: const Icon(Iconsax.people),
            label: const Text('Edit Group'),
          ),
          appBar: AppBar(title: const Text('Edit Group'), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        chatGroupModel.image != ''
                            ? CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                chatGroupModel.image!,
                              ),
                            )
                            : context.read<EditGroupCubit>().image != null
                            ? CircleAvatar(
                              radius: 40,
                              backgroundImage: FileImage(
                                context.read<EditGroupCubit>().image!,
                              ),
                            )
                            : CircleAvatar(
                              radius: 40,
                              child: Icon(Iconsax.people),
                            ),

                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: IconButton(
                            onPressed: () {
                              showCameraOrGallerySheet(
                                context,
                                onCameraSelected: () async {
                                  await context
                                      .read<EditGroupCubit>()
                                      .chooseImage(
                                        isGallery: false,
                                        groupId: chatGroupModel.id!,
                                      );
                                },
                                onGallerySelected: () async {
                                  await context
                                      .read<EditGroupCubit>()
                                      .chooseImage(
                                        isGallery: true,
                                        groupId: chatGroupModel.id!,
                                      );
                                },
                              );
                            },
                            icon: const Icon(Iconsax.camera, size: 30),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Form(
                        key: context.read<EditGroupCubit>().formKey,
                        child: customFeild(
                          controller:
                              context
                                  .read<EditGroupCubit>()
                                  .nameGroupController,
                          labelText: 'Group Name',
                          icon: Iconsax.people,
                          validator: (value) {
                            return value!.isEmpty ? 'Enter Group Name' : null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),

                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Add Members'),
                          const Spacer(),
                          Text(
                            'Members (${context.read<EditGroupCubit>().membersId.length})',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream:
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .where(
                                    'id',
                                    whereNotIn: chatGroupModel.members,
                                  )
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            List<ChatUser> users =
                                snapshot.data!.docs
                                    .map((doc) => ChatUser.fromJson(doc.data()))
                                    .toList();
                            return users.isEmpty
                                ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.profile_remove,
                                        size: 80,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'You do not have any users to add to the group.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                                : // باقي الكود هنا
                                ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    return CheckboxListTile(
                                      title: Text(users[index].name!),
                                      value: context
                                          .read<EditGroupCubit>()
                                          .membersId
                                          .contains(users[index].id),

                                      onChanged: (value) {
                                        context
                                            .read<EditGroupCubit>()
                                            .addMember(users[index].id!);
                                      },
                                    );
                                  },
                                );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
