class ChatUser{
  String? id;
  String? name;
  String? email;
  String? abuot;
  String? image;
  String? createAt;
  String? lastActivated;
  String? pushToken;
  bool? online;

  ChatUser({
    this.id,
    this.name,
    this.email,
    this.abuot,
    this.image,
    this.createAt,
    this.lastActivated,
    this.pushToken,
    this.online,
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
    };
  }
  
}