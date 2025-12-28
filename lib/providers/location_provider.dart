import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

/// Provider for managing user's current location and location services
class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  LatLng? _currentPosition;
  bool _isLoading = false;
  String? _error;
  Stream<LatLng>? _locationStream;

  /// Getters
  LatLng? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLocation => _currentPosition != null;

  /// Initialize location services and get initial position
  Future<void> initializeLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get initial position
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        _currentPosition = position;
        debugPrint('Location initialized: ${position.latitude}, ${position.longitude}');
      } else {
        _error = 'Unable to get location. Please check permissions and GPS.';
      }
    } catch (e) {
      _error = 'Location error: $e';
      debugPrint('Location initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update current position
  Future<void> updatePosition() async {
    try {
      _error = null;
      final position = await _locationService.getCurrentPosition();
      if (position != null && _currentPosition != position) {
        _currentPosition = position;
        debugPrint('Location updated: ${position.latitude}, ${position.longitude}');
        notifyListeners();
      }
    } catch (e) {
      _error = 'Location update error: $e';
      debugPrint('Location update error: $e');
    }
  }

  /// Start listening to location changes
  void startLocationUpdates() {
    if (_locationStream != null) return; // Already listening

    _locationStream = _locationService.getPositionStream();
    _locationStream!.listen(
      (position) {
        if (_currentPosition != position) {
          _currentPosition = position;
          debugPrint('Location stream update: ${position.latitude}, ${position.longitude}');
          notifyListeners();
        }
      },
      onError: (error) {
        _error = 'Location stream error: $error';
        debugPrint('Location stream error: $error');
        notifyListeners();
      },
    );
  }

  /// Stop listening to location changes
  void stopLocationUpdates() {
    _locationStream = null;
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await _locationService.isLocationServiceEnabled();
  }

  /// Check location permissions
  Future<LocationPermission> checkPermission() async {
    return await _locationService.checkPermission();
  }

  /// Request location permissions
  Future<LocationPermission> requestPermission() async {
    final permission = await _locationService.requestPermission();
    // If permission granted, try to get location and start updates
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await initializeLocation();
      startLocationUpdates(); // Start listening for location changes
    }
    return permission;
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }
}
