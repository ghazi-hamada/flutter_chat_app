class MessageModel {
  String? id;
  String? senderId;
  String? reciverId;
  String? message;
  String? type;
  String? time;
  String? read;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.reciverId,
    required this.message,
    required this.type,
    required this.time,
    required this.read,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      reciverId: json['reciver_id'],
      message: json['message'],
      type: json['type'],
      time: json['time'],
      read: json['read'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'reciver_id': reciverId,
      'message': message,
      'type': type,
      'time': time,
      'read': read,
    };
  }
}
