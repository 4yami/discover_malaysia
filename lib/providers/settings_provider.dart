import 'package:flutter/foundation.dart';

/// App settings and preferences
/// Currently uses in-memory storage; can be swapped to SharedPreferences later
class SettingsProvider extends ChangeNotifier {
  // ============ Theme Settings ============
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // ============ Privacy Settings ============
  bool _locationEnabled = true;
  bool get locationEnabled => _locationEnabled;

  void setLocationEnabled(bool value) {
    _locationEnabled = value;
    notifyListeners();
  }

  bool _analyticsEnabled = true;
  bool get analyticsEnabled => _analyticsEnabled;

  void setAnalyticsEnabled(bool value) {
    _analyticsEnabled = value;
    notifyListeners();
  }



  // ============ Reset ============
  void resetToDefaults() {
    _isDarkMode = false;
    _locationEnabled = true;
    _analyticsEnabled = true;
    notifyListeners();
  }
}
