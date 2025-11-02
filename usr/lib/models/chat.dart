class Chat {
  final int id;
  final User user;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String? avatarUrl;

  Chat({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
    this.avatarUrl,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      user: User.fromJson(json['user']),
      lastMessage: json['last_message'],
      lastMessageTime: DateTime.parse(json['last_message_time']),
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'last_message': lastMessage,
      'last_message_time': lastMessageTime.toIso8601String(),
      'avatar_url': avatarUrl,
    };
  }
}