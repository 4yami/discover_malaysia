# Discover Malaysia

A Flutter mobile app for discovering and booking Malaysian cultural tourism destinations.

## Features

### For Tourists
- 🔍 **Browse & Search** – Explore cultural sites, events, food spots, and travel packages
- 📍 **Destination Details** – View images, descriptions, opening hours, ticket prices, and reviews
- 🗺️ **Maps Integration** – Open locations in Google Maps or Waze
- 🎫 **Ticket Booking** – Select ticket types, quantities, visitor names, and visit dates
- 💰 **Price Calculation** – Automatic subtotal, tax (6% SST), and total computation
- 📋 **Booking History** – View upcoming and past bookings

### For Admins
- 📊 **Dashboard** – Overview of sites and recent updates
- ➕ **Site Management** – Add, edit, and delete cultural destinations
- 🏷️ **Categories** – Organize sites into Sites, Events, Packages, and Food

## Getting Started

### Prerequisites
- Flutter SDK 3.9.2+
- Dart SDK

### Installation

```bash
# Clone the repository
git clone https://github.com/C4bbage64/discover_malaysia.git
cd discover_malaysia

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Demo Credentials

| Role  | Email                          | Password      |
|-------|--------------------------------|---------------|
| User  | `john@example.com`             | `password123` |
| Admin | `admin@discovermalaysia.com`   | `admin123`    |

## Project Structure

```
lib/
├── main.dart                 # App entry point with auth wrapper
├── models/
│   ├── booking.dart          # Booking, TicketType, TicketSelection
│   ├── destination.dart      # Destination, TicketPrice, DayHours
│   ├── review.dart           # Review model
│   └── user.dart             # User, UserRole
├── screens/
│   ├── admin/                # Admin dashboard, site list, edit form
│   ├── auth/                 # Login and register pages
│   ├── booking_form_page.dart
│   ├── bookings_page.dart
│   ├── home_page.dart
│   ├── main_navigation.dart
│   ├── profile_page.dart
│   └── site_details_page.dart
└── services/
    ├── auth_service.dart           # Authentication logic
    ├── booking_repository.dart     # Booking CRUD & price calc
    └── destination_repository.dart # Destination CRUD & search
```

## Tech Stack

- **Framework:** Flutter
- **State Management:** StatefulWidget (vanilla Flutter)
- **Navigation:** Navigator 1.0 with MaterialPageRoute
- **External Packages:**
  - `url_launcher` – Open Maps/Waze links
  - `intl` – Date formatting

## Roadmap

- [ ] Payment gateway integration (Stripe / local Malaysian options)
- [ ] Backend API & database persistence
- [ ] Real GPS-based distance & recommendations
- [ ] Image upload for admin site management
- [ ] Multi-language support
- [ ] Push notifications

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is for educational purposes.
