class ChatGroupModel {
  String? id;
  String? name;
  String? image;
  List? members;
  List? admins;
  String? lastMessage;
  String? lastMessageTime;
  String? createAt;

  ChatGroupModel({
   required this.id,
   required this.name,
   required this.image,
   required this.members,
   required this.admins,
   required this.lastMessage,
   required this.lastMessageTime,
   required this.createAt,
  });

  factory ChatGroupModel.fromJson(Map<String, dynamic> json) {
    return ChatGroupModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      members: json['members'],
      admins: json['admins'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'],
      createAt: json['create_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['members'] = members;
    data['admins'] = admins;
    data['last_message'] = lastMessage;
    data['last_message_time'] = lastMessageTime;
    data['create_at'] = createAt;
    return data;
  }
}
