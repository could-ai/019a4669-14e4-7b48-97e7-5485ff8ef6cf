import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../services/telegram_service.dart';
import '../services/database_service.dart';
import '../widgets/chat_list.dart';
import '../widgets/chat_window.dart';
import '../widgets/settings_panel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Chat> chats = [];
  Chat? selectedChat;
  bool showSettings = false;
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    _loadChats();
    _startPolling();
  }

  void _loadChats() async {
    final loadedChats = await DatabaseService().getChats();
    setState(() {
      chats = loadedChats;
    });
  }

  void _startPolling() async {
    final telegramService = TelegramService();
    await telegramService.startPolling((updates) {
      // Process updates: new messages, etc.
      setState(() {
        isOnline = true;
        // Update chats and messages
        _loadChats();
      });
    }, onError: () {
      setState(() {
        isOnline = false;
      });
    });
  }

  void _selectChat(Chat chat) {
    setState(() {
      selectedChat = chat;
    });
  }

  void _toggleSettings() {
    setState(() {
      showSettings = !showSettings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telegram Bot Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _toggleSettings,
          ),
          IconButton(
            icon: Icon(
              Icons.wifi,
              color: isOnline ? Colors.green : Colors.red,
            ),
            onPressed: () {}, // Status indicator
          ),
        ],
      ),
      body: Row(
        children: [
          // Left: Chat list with search
          Expanded(
            flex: 1,
            child: ChatList(
              chats: chats,
              onChatSelected: _selectChat,
              selectedChat: selectedChat,
            ),
          ),
          // Right: Chat window or settings
          Expanded(
            flex: 2,
            child: showSettings
                ? const SettingsPanel()
                : selectedChat != null
                    ? ChatWindow(chat: selectedChat!)
                    : const Center(child: Text('Select a chat')),
          ),
        ],
      ),
    );
  }
}
