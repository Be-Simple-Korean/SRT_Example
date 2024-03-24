import 'package:flutter/material.dart';

class SelectTimeNotifier extends ChangeNotifier {
  SelectTimeNotifier(this._selectedIndex);
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }
}
