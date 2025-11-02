import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:win_toast/win_toast.dart';
import 'package:just_audio/just_audio.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AudioPlayer? _audioPlayer;

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    await _flutterLocalNotificationsPlugin.initialize(settings);

    // For Windows
    await WinToast.instance().initialize();
    _audioPlayer = AudioPlayer();
  }

  Future<void> showNotification(String title, String body, {String? soundPath}) async {
    // Windows notification with sound
    await WinToast.instance().showToast(
      toast: Toast(
        template: ToastType.text02,
        title: title,
        subtitle: body,
      ),
    );

    if (soundPath != null && soundPath.isNotEmpty) {
      try {
        await _audioPlayer?.setFilePath(soundPath);
        await _audioPlayer?.play();
      } catch (e) {
        print("Error playing notification sound: $e");
      }
    }

    // Fallback for other platforms
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'Notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _flutterLocalNotificationsPlugin.show(0, title, body, details);
  }
}
