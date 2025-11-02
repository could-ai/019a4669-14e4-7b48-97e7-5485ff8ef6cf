import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';
import '../services/database_service.dart';

class SettingsPanel extends StatefulWidget {
  const SettingsPanel({super.key});

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _soundController = TextEditingController();
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final settings = await DatabaseService().getSettings();
    if (settings != null) {
      _tokenController.text = settings.botToken ?? '';
      _soundController.text = settings.notificationSoundPath ?? '';
      setState(() => _notificationsEnabled = settings.notificationsEnabled);
    }
  }

  void _saveSettings() async {
    final settings = Settings(
      botToken: _tokenController.text,
      notificationSoundPath: _soundController.text,
      notificationsEnabled: _notificationsEnabled,
    );
    await DatabaseService().saveSettings(settings);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _tokenController,
            decoration: const InputDecoration(labelText: 'Bot Token'),
          ),
          TextField(
            controller: _soundController,
            decoration: const InputDecoration(labelText: 'Notification Sound Path (.wav)'),
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
          ElevatedButton(
            onPressed: _saveSettings,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}