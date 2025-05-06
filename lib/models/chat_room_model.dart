class ChatRoom {
  String? id;
  List? members;
  String? lastMessage;
  String? lastMessageTime;
  String? createAt;

  ChatRoom({
    required this.id,
    required this.members,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'members': members,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'create_at': createAt,
    };
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      members: json['members'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'],
      createAt: json['create_at'],
    );
  }
}
