/// Ticket type for booking
enum TicketType {
  adult,
  child,
  senior,
  student,
  foreignerAdult,
  foreignerChild,
}

/// Extension to get display name and price key for ticket types
extension TicketTypeExtension on TicketType {
  String get displayName {
    switch (this) {
      case TicketType.adult:
        return 'Adult';
      case TicketType.child:
        return 'Child';
      case TicketType.senior:
        return 'Senior';
      case TicketType.student:
        return 'Student';
      case TicketType.foreignerAdult:
        return 'Foreigner Adult';
      case TicketType.foreignerChild:
        return 'Foreigner Child';
    }
  }
}

/// A single ticket selection (type + quantity)
class TicketSelection {
  final TicketType type;
  final int quantity;
  final double pricePerTicket;

  const TicketSelection({
    required this.type,
    required this.quantity,
    required this.pricePerTicket,
  });

  double get subtotal => quantity * pricePerTicket;
}

/// Booking status
enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// A booking for a destination
class Booking {
  final String id;
  final String destinationId;
  final String destinationName;
  final String destinationImage;
  final String userId;
  final List<TicketSelection> tickets;
  final List<String> visitorNames;
  final DateTime visitDate;
  final double subtotal;
  final double taxAmount;
  final double totalPrice;
  final BookingStatus status;
  final DateTime createdAt;
  final String? paymentMethod;
  final String? paymentReference;

  const Booking({
    required this.id,
    required this.destinationId,
    required this.destinationName,
    required this.destinationImage,
    required this.userId,
    required this.tickets,
    required this.visitorNames,
    required this.visitDate,
    required this.subtotal,
    required this.taxAmount,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.paymentMethod,
    this.paymentReference,
  });

  /// Total number of tickets
  int get totalTickets => tickets.fold(0, (sum, t) => sum + t.quantity);

  /// Formatted visit date
  String get formattedVisitDate {
    return '${visitDate.day}/${visitDate.month}/${visitDate.year}';
  }

  /// Formatted total price
  String get formattedTotalPrice => 'RM ${totalPrice.toStringAsFixed(2)}';
}
