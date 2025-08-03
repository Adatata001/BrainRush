import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService with ChangeNotifier {
  bool _isSfxOn = true;
  
  SoundService() {
    _loadSettings();
  }

  bool get isSfxOn => _isSfxOn;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isSfxOn = prefs.getBool('isSfxOn') ?? true;
    notifyListeners();
  }

    Future<void> setSfx(bool value) async {
      _isSfxOn = value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSfxOn', value);
      notifyListeners();
    }

  Future<void> toggleSfx() async {
    _isSfxOn = !_isSfxOn;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSfxOn', _isSfxOn);
    notifyListeners();
  }
}