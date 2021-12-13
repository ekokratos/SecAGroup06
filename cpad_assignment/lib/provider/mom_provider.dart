import 'dart:collection';
import 'package:cpad_assignment/models/mom.dart';
import 'package:flutter/material.dart';

class MOMProvider extends ChangeNotifier {
  List<MOM> _momList = [];

  int get momsCount => _momList.length;

  UnmodifiableListView<MOM> get momList {
    return UnmodifiableListView(_momList);
  }

  void updateMOMList(List<MOM> momList) {
    _momList.clear();
    _momList = List.from(momList);
    _momList.sort((a, b) {
      DateTime firstDate = DateTime.tryParse(a.date!)!;
      DateTime secondDate = DateTime.tryParse(b.date!)!;
      return secondDate.compareTo(firstDate);
    });
    notifyListeners();
  }

  void addMOM(MOM mom) {
    if (!_momList.contains(mom)) {
      _momList.add(mom);
      _momList.sort((a, b) => a.date.toString().compareTo(b.date.toString()));
    }
    notifyListeners();
  }

  void deleteMOM(MOM mom) {
    _momList.remove(mom);
    notifyListeners();
  }
}
