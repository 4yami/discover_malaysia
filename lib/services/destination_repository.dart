import '../models/destination.dart';
import '../models/review.dart';
import 'interfaces/destination_repository_interface.dart';

/// Repository for accessing destination data
/// Currently uses local/dummy data; can be swapped to API later
class DestinationRepository implements IDestinationRepository {
  static final DestinationRepository _instance = DestinationRepository._internal();
  factory DestinationRepository() => _instance;
  DestinationRepository._internal();

  /// Get all destinations
  @override
  List<Destination> getAllDestinations() => _destinations;

  /// Get destinations by category
  @override
  List<Destination> getByCategory(DestinationCategory category) {
    return _destinations.where((d) => d.category == category).toList();
  }

  /// Get featured destinations (top rated)
  @override
  List<Destination> getFeatured({int limit = 3}) {
    final sorted = List<Destination>.from(_destinations)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(limit).toList();
  }

  /// Get nearby destinations (sorted by distance)
  @override
  List<Destination> getNearby({int limit = 5}) {
    final withDistance = _destinations.where((d) => d.distanceKm != null).toList()
      ..sort((a, b) => a.distanceKm!.compareTo(b.distanceKm!));
    return withDistance.take(limit).toList();
  }

  /// Search destinations by name or description
  @override
  List<Destination> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return _destinations;
    return _destinations.where((d) {
      return d.name.toLowerCase().contains(q) ||
          d.shortDescription.toLowerCase().contains(q) ||
          d.detailedDescription.toLowerCase().contains(q);
    }).toList();
  }

  /// Get a destination by ID
  @override
  Destination? getById(String id) {
    try {
      return _destinations.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get reviews for a destination
  @override
  List<Review> getReviewsForDestination(String destinationId) {
    return _reviews.where((r) => r.destinationId == destinationId).toList();
  }

  // ============ ADMIN METHODS ============

  /// Add a new destination (admin only)
  @override
  Future<void> addDestination(Destination destination) async {
    _destinations.add(destination);
  }

  /// Update an existing destination (admin only)
  @override
  Future<void> updateDestination(Destination destination) async {
    final index = _destinations.indexWhere((d) => d.id == destination.id);
    if (index != -1) {
      _destinations[index] = destination;
    }
  }

  /// Delete a destination (admin only)
  @override
  Future<void> deleteDestination(String id) async {
    _destinations.removeWhere((d) => d.id == id);
  }

  // ============ DUMMY DATA ============

  final List<Destination> _destinations = [];

  final List<Review> _reviews = [];
}
