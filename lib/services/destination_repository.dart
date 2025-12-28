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

  final List<Destination> _destinations = [
    Destination(
      id: 'petronas-towers',
      name: 'Petronas Twin Towers',
      shortDescription: 'Iconic twin skyscrapers and Malaysia\'s tallest buildings',
      detailedDescription: 'The Petronas Twin Towers are an iconic symbol of Kuala Lumpur and Malaysia. Standing at 452 meters tall, they were the tallest buildings in the world from 1998 to 2004. The towers feature a skybridge connecting the two buildings at the 41st and 42nd floors.',
      category: DestinationCategory.sites,
      address: 'Kuala Lumpur City Centre, 50088 Kuala Lumpur',
      latitude: 3.1578,
      longitude: 101.7123,
      images: ['https://example.com/petronas1.jpg', 'https://example.com/petronas2.jpg'],
      openingHours: [
        DayHours(day: 'Monday', hours: '9:00 AM - 9:00 PM'),
        DayHours(day: 'Tuesday', hours: '9:00 AM - 9:00 PM'),
        DayHours(day: 'Wednesday', hours: '9:00 AM - 9:00 PM'),
        DayHours(day: 'Thursday', hours: '9:00 AM - 9:00 PM'),
        DayHours(day: 'Friday', hours: '9:00 AM - 9:00 PM'),
        DayHours(day: 'Saturday', hours: '9:00 AM - 9:00 PM'),
        DayHours(day: 'Sunday', hours: '9:00 AM - 9:00 PM'),
      ],
      ticketPrice: TicketPrice(
        adult: 85,
        child: 35,
        senior: 35,
        student: 35,
        foreignerAdult: 105,
        foreignerChild: 45,
      ),
      rating: 4.5,
      reviewCount: 1247,
    ),
    Destination(
      id: 'national-museum',
      name: 'National Museum',
      shortDescription: 'Malaysia\'s premier museum showcasing the country\'s history and culture',
      detailedDescription: 'The National Museum of Malaysia is the premier museum in the country, showcasing Malaysia\'s history, culture, and heritage. The museum features exhibits on Malay history, Islamic civilization, and the formation of Malaysia as a nation.',
      category: DestinationCategory.sites,
      address: 'Jalan Damansara, 50566 Kuala Lumpur',
      latitude: 3.1363,
      longitude: 101.6865,
      images: ['https://example.com/museum1.jpg', 'https://example.com/museum2.jpg'],
      openingHours: [
        DayHours(day: 'Tuesday', hours: '9:00 AM - 6:00 PM'),
        DayHours(day: 'Wednesday', hours: '9:00 AM - 6:00 PM'),
        DayHours(day: 'Thursday', hours: '9:00 AM - 6:00 PM'),
        DayHours(day: 'Friday', hours: '9:00 AM - 6:00 PM'),
        DayHours(day: 'Saturday', hours: '9:00 AM - 6:00 PM'),
        DayHours(day: 'Sunday', hours: '9:00 AM - 6:00 PM'),
        DayHours(day: 'Monday', hours: 'Closed', isClosed: true),
      ],
      ticketPrice: TicketPrice(
        adult: 5,
        child: 2,
        senior: 2,
        student: 2,
        foreignerAdult: 10,
        foreignerChild: 5,
      ),
      rating: 4.2,
      reviewCount: 892,
    ),
    Destination(
      id: 'batu-caves',
      name: 'Batu Caves',
      shortDescription: 'Sacred Hindu temple complex featuring massive golden statue',
      detailedDescription: 'Batu Caves is a limestone hill that has been converted into a Hindu temple complex. The site features a series of caves and cave temples, with the main attraction being the 42.7-meter tall golden statue of Lord Murugan at the entrance.',
      category: DestinationCategory.sites,
      address: 'Gombak, 68100 Batu Caves, Selangor',
      latitude: 3.2379,
      longitude: 101.6831,
      images: ['https://example.com/batu1.jpg', 'https://example.com/batu2.jpg'],
      openingHours: [
        DayHours(day: 'Monday', hours: '6:00 AM - 9:00 PM'),
        DayHours(day: 'Tuesday', hours: '6:00 AM - 9:00 PM'),
        DayHours(day: 'Wednesday', hours: '6:00 AM - 9:00 PM'),
        DayHours(day: 'Thursday', hours: '6:00 AM - 9:00 PM'),
        DayHours(day: 'Friday', hours: '6:00 AM - 9:00 PM'),
        DayHours(day: 'Saturday', hours: '6:00 AM - 9:00 PM'),
        DayHours(day: 'Sunday', hours: '6:00 AM - 9:00 PM'),
      ],
      ticketPrice: TicketPrice(
        adult: 10,
        child: 5,
        senior: 5,
        student: 5,
        foreignerAdult: 15,
        foreignerChild: 8,
      ),
      rating: 4.3,
      reviewCount: 2156,
    ),
    Destination(
      id: 'bird-park',
      name: 'KL Bird Park',
      shortDescription: 'World\'s largest free-flight bird park with over 3,000 birds',
      detailedDescription: 'The KL Bird Park is the world\'s largest free-flight bird park, home to over 3,000 birds from 200 species. Visitors can walk through aviaries and see birds flying freely around them.',
      category: DestinationCategory.sites,
      address: 'Jalan Cenderawasih, 50480 Kuala Lumpur',
      latitude: 3.1419,
      longitude: 101.6917,
      images: ['https://example.com/bird1.jpg', 'https://example.com/bird2.jpg'],
      openingHours: [
        DayHours(day: 'Monday', hours: '9:00 AM - 6:00 PM'),
        DayHours(day: 'Tuesday', hours: '9:00 AM - 6:00 PM'),
        DayHours(day: 'Wednesday', hours: '9:00 AM - 6:00 PM'),
        DayHours(day: 'Thursday', hours: '9:00 AM - 6:00 PM'),
        DayHours(day: 'Friday', hours: '9:00 AM - 6:00 PM'),
        DayHours(day: 'Saturday', hours: '9:00 AM - 6:00 PM'),
        DayHours(day: 'Sunday', hours: '9:00 AM - 6:00 PM'),
      ],
      ticketPrice: TicketPrice(
        adult: 50,
        child: 35,
        senior: 35,
        student: 35,
        foreignerAdult: 65,
        foreignerChild: 45,
      ),
      rating: 4.1,
      reviewCount: 756,
    ),
    Destination(
      id: 'jalan-alor',
      name: 'Jalan Alor',
      shortDescription: 'Bustling street food paradise in the heart of Kuala Lumpur',
      detailedDescription: 'Jalan Alor is Kuala Lumpur\'s most famous street food destination, offering a wide variety of local delicacies from Malay, Chinese, and Indian cuisines. The street comes alive at night with food stalls serving everything from satay to char kway teow.',
      category: DestinationCategory.food,
      address: 'Jalan Alor, Bukit Bintang, 55100 Kuala Lumpur',
      latitude: 3.1438,
      longitude: 101.7081,
      images: ['https://example.com/jalan1.jpg', 'https://example.com/jalan2.jpg'],
      openingHours: [
        DayHours(day: 'Monday', hours: '5:00 PM - 2:00 AM'),
        DayHours(day: 'Tuesday', hours: '5:00 PM - 2:00 AM'),
        DayHours(day: 'Wednesday', hours: '5:00 PM - 2:00 AM'),
        DayHours(day: 'Thursday', hours: '5:00 PM - 2:00 AM'),
        DayHours(day: 'Friday', hours: '5:00 PM - 2:00 AM'),
        DayHours(day: 'Saturday', hours: '5:00 PM - 2:00 AM'),
        DayHours(day: 'Sunday', hours: '5:00 PM - 2:00 AM'),
      ],
      ticketPrice: TicketPrice(
        adult: 0,
        child: 0,
        senior: 0,
        student: 0,
        foreignerAdult: 0,
        foreignerChild: 0,
      ),
      rating: 4.4,
      reviewCount: 3421,
    ),
  ];

  final List<Review> _reviews = [
    Review(
      id: 'review-1',
      destinationId: 'national-museum',
      userId: 'user-1',
      username: 'Ahmad Rahman',
      comment: 'Great museum with comprehensive exhibits on Malaysian history. Highly recommended!',
      rating: 5,
      timestamp: DateTime(2024, 1, 15),
    ),
    Review(
      id: 'review-2',
      destinationId: 'petronas-towers',
      userId: 'user-2',
      username: 'Sarah Chen',
      comment: 'Amazing view from the skybridge. The architecture is stunning.',
      rating: 4,
      timestamp: DateTime(2024, 2, 20),
    ),
  ];
}
