import 'dart:collection';

import 'package:cpad_assignment/models/poll.dart';
import 'package:flutter/foundation.dart';

class PollProvider extends ChangeNotifier {
  List<Poll> _pollList = [];

  int get pollCount => _pollList.length;

  UnmodifiableListView<Poll> get pollList {
    return UnmodifiableListView(_pollList);
  }

  void updatePollList(List<Poll> pollList) {
    _pollList.clear();
    _pollList = List.from(pollList);
    _pollList.sort(
        (a, b) => a.timestamp.toString().compareTo(b.timestamp.toString()));
    notifyListeners();
  }

  void addPoll(Poll poll) {
    if (!_pollList.contains(poll)) {
      _pollList.add(poll);
      _pollList.sort((a, b) => a.timestamp!.compareTo(b.toString()));
    }
    notifyListeners();
  }

  void deletePoll(Poll poll) {
    _pollList.remove(poll);
    notifyListeners();
  }
}
