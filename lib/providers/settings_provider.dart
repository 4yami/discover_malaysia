import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

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

  final LocationService _locationService = LocationService();

  Future<void> setLocationEnabled(bool value) async {
    if (value) {
      // When enabling location, request permissions
      final permission = await _locationService.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestedPermission = await _locationService.requestPermission();
        if (requestedPermission == LocationPermission.denied ||
            requestedPermission == LocationPermission.deniedForever) {
          // Permission denied, don't enable location
          _locationEnabled = false;
          notifyListeners();
          return;
        }
      }

      // Check if location services are enabled
      final serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are disabled, but we'll still set the preference
        // The app will handle this when trying to get location
      }
    }

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
