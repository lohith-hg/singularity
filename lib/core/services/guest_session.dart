import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks whether the user is browsing as a guest (skipped login).
///
/// Holds the flag in memory so the GoRouter `redirect` can read it
/// synchronously, while persisting to [SharedPreferences] so a returning
/// guest goes straight to `/home`. Extends [ChangeNotifier] so the router's
/// `refreshListenable` re-runs the redirect whenever guest mode toggles.
class GuestSession extends ChangeNotifier {
  static const _key = 'guest_mode';

  bool _active = false;
  bool get isActive => _active;

  /// Loads the persisted flag once at startup, before the router evaluates.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _active = prefs.getBool(_key) ?? false;
  }

  Future<void> enter() async {
    if (_active) return;
    _active = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    notifyListeners();
  }

  Future<void> exit() async {
    if (!_active) return;
    _active = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
    notifyListeners();
  }
}
