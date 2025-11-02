import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/telegram_service.dart';

class MessageInput extends StatefulWidget {
  final Function(String, {int? replyToMessageId}) onSend;

  const MessageInput({super.key, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  int? _replyToMessageId;

  void _send() {
    if (_controller.text.isNotEmpty) {
      widget.onSend(_controller.text, replyToMessageId: _replyToMessageId);
      _controller.clear();
      setState(() => _replyToMessageId = null);
    }
  }

  void _attachFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // Send file via Telegram API (extend TelegramService)
      // For now, placeholder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[100],
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: _attachFile,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _send,
          ),
        ],
      ),
    );
  }
}