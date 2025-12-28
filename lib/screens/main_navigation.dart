import 'package:discover_malaysia/screens/home_page.dart';
import 'package:discover_malaysia/screens/profile_page.dart';
import 'package:discover_malaysia/screens/bookings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/location_provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}



class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize user data when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        debugPrint('Initializing data for user: ${user.id}');
        context.read<BookingProvider>().initForUser(user.id);
        context.read<FavoritesProvider>().initForUser(user.id);

        // Request location permission after user logs in
        _requestLocationPermission();
      }
    });
  }

  Future<void> _requestLocationPermission() async {
    final locationProvider = context.read<LocationProvider>();

    // Show dialog asking for location permission
    if (mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enable Location Services'),
          content: const Text(
            'To show distances to nearby sites and provide a better experience, '
            'please enable location services.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Not Now'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Request location permission and get location
                await locationProvider.requestPermission();
              },
              child: const Text('Enable'),
            ),
          ],
        ),
      );
    }
  }

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    BookingsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
