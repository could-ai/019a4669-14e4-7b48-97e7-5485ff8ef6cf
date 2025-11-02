import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../services/database_service.dart';
import '../services/telegram_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatWindow extends StatefulWidget {
  final Chat chat;

  const ChatWindow({super.key, required this.chat});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  List<Message> messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    final loadedMessages = await DatabaseService().getMessages(widget.chat.id);
    setState(() {
      messages = loadedMessages;
    });
  }

  void _sendMessage(String text, {int? replyToMessageId}) async {
    await TelegramService().sendMessage(widget.chat.id, text, replyToMessageId: replyToMessageId);
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top bar with user name and profile button
        AppBar(
          title: Text(widget.chat.user.firstName ?? 'Chat'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Show profile popup
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        // Messages list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return MessageBubble(message: messages[index]);
            },
          ),
        ),
        // Input field
        MessageInput(onSend: _sendMessage),
      ],
    );
  }
}