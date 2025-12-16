/// Category for a destination/cultural site
enum DestinationCategory {
  sites,
  events,
  packages,
  food,
}

/// Represents ticket pricing for different visitor types
class TicketPrice {
  final double adult;
  final double child;
  final double senior;
  final double student;
  final double foreignerAdult;
  final double foreignerChild;

  const TicketPrice({
    required this.adult,
    required this.child,
    required this.senior,
    required this.student,
    required this.foreignerAdult,
    required this.foreignerChild,
  });

  /// Returns a map of ticket type label to price
  Map<String, double> toMap() => {
        'Adult': adult,
        'Child': child,
        'Senior': senior,
        'Student': student,
        'Foreigner Adult': foreignerAdult,
        'Foreigner Child': foreignerChild,
      };

  /// Check if entry is free
  bool get isFree =>
      adult == 0 &&
      child == 0 &&
      senior == 0 &&
      student == 0 &&
      foreignerAdult == 0 &&
      foreignerChild == 0;
}

/// Opening hours for a single day
class DayHours {
  final String day;
  final String hours;
  final bool isClosed;

  const DayHours({
    required this.day,
    required this.hours,
    this.isClosed = false,
  });
}

/// A cultural destination/site
class Destination {
  final String id;
  final String name;
  final String shortDescription;
  final String detailedDescription;
  final DestinationCategory category;
  final String address;
  final double latitude;
  final double longitude;
  final String? googleMapsUrl;
  final String? wazeUrl;
  final List<String> images;
  final List<DayHours> openingHours;
  final TicketPrice ticketPrice;
  final double rating;
  final int reviewCount;
  final double? distanceKm;
  final DateTime? lastUpdatedAt;
  final String? updatedByAdminId;

  const Destination({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.detailedDescription,
    required this.category,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.googleMapsUrl,
    this.wazeUrl,
    required this.images,
    required this.openingHours,
    required this.ticketPrice,
    required this.rating,
    required this.reviewCount,
    this.distanceKm,
    this.lastUpdatedAt,
    this.updatedByAdminId,
  });

  /// Returns formatted price string for display (e.g., "RM 5.00" or "FREE")
  String get displayPrice {
    if (ticketPrice.isFree) return 'FREE';
    return 'RM ${ticketPrice.adult.toStringAsFixed(2)}';
  }

  /// Returns formatted distance string
  String get displayDistance {
    if (distanceKm == null) return 'Distance N/A';
    return '${distanceKm!.toStringAsFixed(1)}km away';
  }

  /// Generate Google Maps URL from coordinates if not provided
  String get effectiveGoogleMapsUrl {
    if (googleMapsUrl != null && googleMapsUrl!.isNotEmpty) {
      return googleMapsUrl!;
    }
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }

  /// Generate Waze URL from coordinates if not provided
  String get effectiveWazeUrl {
    if (wazeUrl != null && wazeUrl!.isNotEmpty) {
      return wazeUrl!;
    }
    return 'https://waze.com/ul?ll=$latitude,$longitude&navigate=yes';
  }
}
