class Settings {
  final String? botToken;
  final String? notificationSoundPath;
  final bool notificationsEnabled;

  Settings({
    this.botToken,
    this.notificationSoundPath,
    this.notificationsEnabled = true,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      botToken: json['bot_token'],
      notificationSoundPath: json['notification_sound_path'],
      notificationsEnabled: json['notifications_enabled'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bot_token': botToken,
      'notification_sound_path': notificationSoundPath,
      'notifications_enabled': notificationsEnabled ? 1 : 0,
    };
  }
}