import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../models/settings.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'telegram_bot.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT,
        first_name TEXT,
        last_name TEXT,
        bio TEXT,
        profile_photo_url TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE chats (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        last_message TEXT,
        last_message_time TEXT,
        avatar_url TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY,
        chat_id INTEGER,
        is_from_bot INTEGER,
        text TEXT,
        type INTEGER,
        file_url TEXT,
        timestamp TEXT,
        reply_to_message_id INTEGER,
        FOREIGN KEY (chat_id) REFERENCES chats (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        bot_token TEXT,
        notification_sound_path TEXT,
        notifications_enabled INTEGER
      )
    ''');
  }

  Future<List<Chat>> getChats() async {
    final db = await database;
    final result = await db.query('chats');
    return result.map((json) => Chat.fromJson(json)).toList();
  }

  Future<void> saveChat(Chat chat) async {
    final db = await database;
    await db.insert('chats', chat.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Message>> getMessages(int chatId) async {
    final db = await database;
    final result = await db.query('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    return result.map((json) => Message.fromJson(json)).toList();
  }

  Future<void> saveMessage(Message message) async {
    final db = await database;
    await db.insert('messages', message.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Settings?> getSettings() async {
    final db = await database;
    final result = await db.query('settings');
    if (result.isNotEmpty) {
      return Settings.fromJson(result.first);
    }
    return null;
  }

  Future<void> saveSettings(Settings settings) async {
    final db = await database;
    await db.insert('settings', settings.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}