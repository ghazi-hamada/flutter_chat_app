import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/home/chat/chat_cubit/chat_cubit.dart';
import 'package:flutter_chat_app/home/chat/widgets/card_chat.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:flutter_chat_app/models/message_model.dart';

class ChatMessagesView extends StatelessWidget {
  final String roomId;
  final ChatUser user; // استخدم الموديل المناسب لديك

  const ChatMessagesView({super.key, required this.roomId, required this.user});

  void _handleSelect(BuildContext context, MessageModel message) {
    final cubit = context.read<ChatCubit>();
    cubit.selectMessage(message.id!);
    cubit.selectMessageText(message.message ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance
                .collection('rooms')
                .doc(roomId)
                .collection('messages')
                .orderBy('time', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final messages =
              snapshot.data!.docs
                  .map((doc) => MessageModel.fromJson(doc.data()))
                  .toList();

          final selectedIds = context.watch<ChatCubit>().messagesIdSelected;

          if (messages.isEmpty) {
            return InkWell(
              onTap: () {
                context.read<ChatCubit>().sendMessage(
                  user,
                  roomId,
                  'AlSalam alaikum 👋',
                );
              },
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '👋',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Text(
                          'Say AlSalam Alaikum',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: messages.length,
            reverse: true,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isSelected = selectedIds.contains(message.id);
              final messageTime = DateTime.fromMillisecondsSinceEpoch(
                int.parse(message.time ?? '0') ?? 0,
              );

              // تحديد إذا كنا بحاجة لعرض تاريخ
              bool showDateHeader = false;
              final currentDate = DateTime(
                messageTime.year,
                messageTime.month,
                messageTime.day,
              );

              if (index == messages.length - 1) {
                showDateHeader = true;
              } else {
                final nextMessageTime = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(messages[index + 1].time ?? '0') ?? 0,
                );
                final nextDate = DateTime(
                  nextMessageTime.year,
                  nextMessageTime.month,
                  nextMessageTime.day,
                );
                showDateHeader = currentDate != nextDate;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showDateHeader)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        formatDateHeader(messageTime),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onLongPress: () => _handleSelect(context, message),
                    onTap:
                        selectedIds.isNotEmpty
                            ? () => _handleSelect(context, message)
                            : null,
                    child: CardChat(
                      selected: isSelected,
                      messageModel: message,
                      roomId: roomId,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

String formatDateHeader(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final messageDate = DateTime(date.year, date.month, date.day);
  final difference = today.difference(messageDate).inDays;

  if (difference == 0) return 'اليوم';
  if (difference == 1) return 'أمس';
  return '${date.day}/${date.month}/${date.year}';
}
