import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';
import '../models/settings.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class TelegramService {
  final String baseUrl = 'https://api.telegram.org/bot';
  String? _token;

  Future<void> setToken(String token) async {
    _token = token;
  }

  Future<void> startPolling(Function onUpdate, {Function? onError}) async {
    final settings = await DatabaseService().getSettings();
    if (settings?.botToken == null) return;
    _token = settings!.botToken;

    int offset = 0;
    while (true) {
      try {
        final response = await http.get(Uri.parse('$baseUrl$_token/getUpdates?offset=$offset'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final updates = data['result'] as List;
          for (var update in updates) {
            // Process message
            if (update['message'] != null) {
              final message = _parseMessage(update['message']);
              await DatabaseService().saveMessage(message);
              await NotificationService().showNotification('New message', message.text);
              offset = update['update_id'] + 1;
            }
          }
          onUpdate(updates);
        } else {
          onError?.call();
        }
      } catch (e) {
        onError?.call();
      }
      await Future.delayed(const Duration(seconds: 1)); // Polling interval
    }
  }

  Message _parseMessage(Map<String, dynamic> json) {
    return Message(
      id: json['message_id'],
      chatId: json['chat']['id'],
      isFromBot: false, // Assume user messages
      text: json['text'] ?? '',
      type: MessageType.text, // Extend for attachments
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['date'] * 1000),
    );
  }

  Future<void> sendMessage(int chatId, String text, {int? replyToMessageId}) async {
    if (_token == null) return;
    final response = await http.post(
      Uri.parse('$baseUrl$_token/sendMessage'),
      body: {
        'chat_id': chatId.toString(),
        'text': text,
        'reply_to_message_id': replyToMessageId?.toString(),
      },
    );
    if (response.statusCode == 200) {
      // Save sent message
      final sentMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch, // Temp ID
        chatId: chatId,
        isFromBot: true,
        text: text,
        type: MessageType.text,
        timestamp: DateTime.now(),
        replyToMessageId: replyToMessageId,
      );
      await DatabaseService().saveMessage(sentMessage);
    }
  }

  // Add methods for sendPhoto, sendDocument, etc. similarly
}