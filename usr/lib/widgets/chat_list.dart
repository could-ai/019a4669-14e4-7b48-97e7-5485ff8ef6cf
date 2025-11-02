import 'package:flutter/material.dart';
import '../models/chat.dart';

class ChatList extends StatefulWidget {
  final List<Chat> chats;
  final Function(Chat) onChatSelected;
  final Chat? selectedChat;

  const ChatList({
    super.key,
    required this.chats,
    required this.onChatSelected,
    this.selectedChat,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  String searchQuery = '';

  List<Chat> get filteredChats {
    if (searchQuery.isEmpty) return widget.chats;
    return widget.chats.where((chat) =>
      chat.user.firstName?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false ||
      chat.lastMessage.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search chats',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => searchQuery = value),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredChats.length,
            itemBuilder: (context, index) {
              final chat = filteredChats[index];
              return ListTile(
                selected: chat.id == widget.selectedChat?.id,
                leading: CircleAvatar(
                  backgroundImage: chat.avatarUrl != null ? NetworkImage(chat.avatarUrl!) : null,
                  child: chat.avatarUrl == null ? Text(chat.user.firstName?[0] ?? '?') : null,
                ),
                title: Text(chat.user.firstName ?? 'Unknown'),
                subtitle: Text(chat.lastMessage, maxLines: 1),
                onTap: () => widget.onChatSelected(chat),
              );
            },
          ),
        ),
      ],
    );
  }
}