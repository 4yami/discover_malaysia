import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void goToHome() => setSelectedIndex(0);
  void goToBookings() => setSelectedIndex(1);
  void goToProfile() => setSelectedIndex(2);
}
