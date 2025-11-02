enum MessageType { text, photo, video, document, audio, sticker }

class Message {
  final int id;
  final int chatId;
  final bool isFromBot;
  final String text;
  final MessageType type;
  final String? fileUrl;
  final DateTime timestamp;
  final int? replyToMessageId;

  Message({
    required this.id,
    required this.chatId,
    required this.isFromBot,
    required this.text,
    required this.type,
    this.fileUrl,
    required this.timestamp,
    this.replyToMessageId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chat_id'],
      isFromBot: json['is_from_bot'] == 1,
      text: json['text'],
      type: MessageType.values[json['type']],
      fileUrl: json['file_url'],
      timestamp: DateTime.parse(json['timestamp']),
      replyToMessageId: json['reply_to_message_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'is_from_bot': isFromBot ? 1 : 0,
      'text': text,
      'type': type.index,
      'file_url': fileUrl,
      'timestamp': timestamp.toIso8601String(),
      'reply_to_message_id': replyToMessageId,
    };
  }
}