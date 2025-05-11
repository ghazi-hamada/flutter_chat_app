class ChatUser {
  String? id;
  String? name;
  String? email;
  String? abuot;
  String? image;
  String? createAt;
  String? lastActivated;
  String? pushToken;
  bool? online;
  List? myContacts;

  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.abuot,
    required this.image,
    required this.createAt,
    required this.lastActivated,
    required this.pushToken,
    required this.online,
    required this.myContacts,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      abuot: json['abuot'],
      image: json['image'],
      createAt: json['create_at'],
      lastActivated: json['last_activated'],
      pushToken: json['push_token'],
      online: json['online'],
      myContacts: json['my_contacts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'abuot': abuot,
      'image': image,
      'create_at': createAt,
      'last_activated': lastActivated,
      'push_token': pushToken,
      'online': online,
      'my_contacts': myContacts,
    };
  }
}
