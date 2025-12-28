import 'package:flutter/foundation.dart';
import '../models/destination.dart';
import '../models/review.dart';
import '../services/destination_repository.dart';
import '../services/firebase_destination_repository.dart';
import '../services/interfaces/destination_repository_interface.dart';

/// ChangeNotifier wrapper for destination state
/// Allows widgets to rebuild when destinations change
class DestinationProvider extends ChangeNotifier {
  final IDestinationRepository _repository;
  // ignore: prefer_final_fields
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  DestinationProvider({IDestinationRepository? repository})
      : _repository = repository ?? FirebaseDestinationRepository() {
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    if (_repository is FirebaseDestinationRepository) {
      _isLoading = true;
      notifyListeners();
      
      await _repository.initialize();
      
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============ Getters ============

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  /// Get all destinations
  List<Destination> get allDestinations {
    final destinations = _repository.getAllDestinations();
    // If Firebase cache is empty, fall back to dummy data for development
    if (destinations.isEmpty && _repository is FirebaseDestinationRepository) {
      return DestinationRepository().getAllDestinations();
    }
    return destinations;
  }

  /// Get destinations by category
  List<Destination> getByCategory(DestinationCategory category) {
    final destinations = _repository.getByCategory(category);
    // If Firebase returns empty, fall back to dummy data
    if (destinations.isEmpty && _repository is FirebaseDestinationRepository) {
      return DestinationRepository().getByCategory(category);
    }
    return destinations;
  }

  /// Get featured destinations (top rated)
  List<Destination> getFeatured({int limit = 3}) {
    final destinations = _repository.getFeatured(limit: limit);
    // If Firebase returns empty, fall back to dummy data
    if (destinations.isEmpty && _repository is FirebaseDestinationRepository) {
      return DestinationRepository().getFeatured(limit: limit);
    }
    return destinations;
  }

  /// Get nearby destinations (sorted by distance)
  List<Destination> getNearby({int limit = 5}) {
    final destinations = _repository.getNearby(limit: limit);
    // If Firebase returns empty, fall back to dummy data
    if (destinations.isEmpty && _repository is FirebaseDestinationRepository) {
      return DestinationRepository().getNearby(limit: limit);
    }
    return destinations;
  }

  /// Search destinations by name or description
  List<Destination> search(String query) {
    _searchQuery = query;
    final destinations = _repository.search(query);
    // If Firebase returns empty and query is not empty, fall back to dummy data
    if (destinations.isEmpty && query.isNotEmpty && _repository is FirebaseDestinationRepository) {
      return DestinationRepository().search(query);
    }
    return destinations;
  }

  /// Get current search results
  List<Destination> get searchResults {
    if (_searchQuery.isEmpty) return allDestinations;
    return search(_searchQuery);
  }

  /// Get a destination by ID
  Destination? getById(String id) {
    return _repository.getById(id);
  }

  // Cache for reviews
  final Map<String, List<Review>> _reviewsCache = {};

  /// Get reviews for a destination
  List<Review> getReviewsForDestination(String destinationId) {
    if (_repository is FirebaseDestinationRepository) {
      // If we don't have cached reviews for this destination, start streaming them
      if (!_reviewsCache.containsKey(destinationId)) {
        _reviewsCache[destinationId] = []; // Initialize empty
        _repository
            .streamReviews(destinationId)
            .listen((reviews) {
          _reviewsCache[destinationId] = reviews;
          notifyListeners();
        });
      }
      return _reviewsCache[destinationId] ?? [];
    }
    return _repository.getReviewsForDestination(destinationId);
  }

  /// Add a new review
  Future<void> addReview(Review review) async {
    if (_repository is FirebaseDestinationRepository) {
      await _repository.addReview(review);
    } else {
      // Logic for non-Firebase repository if needed
    }
  }

  // ============ Admin Actions ============

  /// Add a new destination (admin only)
  Future<void> addDestination(Destination destination) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _repository.addDestination(destination);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update an existing destination (admin only)
  Future<void> updateDestination(Destination destination) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _repository.updateDestination(destination);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a destination (admin only)
  Future<void> deleteDestination(String id) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _repository.deleteDestination(id);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============ Search & Filter ============

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }



  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Seed the database with dummy data (One-time use)
  Future<void> seedDatabase() async {
    if (_repository is FirebaseDestinationRepository) {
      try {
        _isLoading = true;
        notifyListeners();

        // Get dummy data from the local repository
        final dummyData = DestinationRepository().getAllDestinations();
        
        await _repository.seedData(dummyData);
        
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
        rethrow;
      }
    }
  }
}
