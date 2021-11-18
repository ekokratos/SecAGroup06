import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:cpad_assignment/models/user.dart';

class MembersProvider extends ChangeNotifier {
  List<AppUser> _pendingMembers = [];
  List<AppUser> _acceptedMembers = [];
  List<AppUser> _rejectedMembers = [];

  int get pendingMembersCount => _pendingMembers.length;

  int get acceptedMembersCount => _acceptedMembers.length;

  int get rejectedMembersCount => _rejectedMembers.length;

  UnmodifiableListView<AppUser> get pendingMembers {
    return UnmodifiableListView(_pendingMembers);
  }

  UnmodifiableListView<AppUser> get acceptedMembers {
    return UnmodifiableListView(_acceptedMembers);
  }

  UnmodifiableListView<AppUser> get rejectedMembers {
    return UnmodifiableListView(_rejectedMembers);
  }

  void addPendingMember(AppUser user) {
    bool noUser =
        _pendingMembers.every((existingUser) => user.id != existingUser.id);
    if (noUser) _pendingMembers.add(user);
    notifyListeners();
  }

  void deletePendingMember(AppUser user) {
    _pendingMembers.remove(user);
    notifyListeners();
  }

  void addAcceptedMember(AppUser user) {
    bool userNotFoundInAccepted =
        _acceptedMembers.every((existingUser) => user.id != existingUser.id);
    if (userNotFoundInAccepted) _acceptedMembers.add(user);

    bool userNotFoundInPending =
        _pendingMembers.every((existingUser) => user.id != existingUser.id);
    if (!userNotFoundInPending)
      _pendingMembers.removeWhere((existingUser) => user.id == existingUser.id);

    notifyListeners();
  }

  void addRejectedMember(AppUser user) {
    bool userNotFoundInRejected =
        _rejectedMembers.every((existingUser) => user.id != existingUser.id);
    if (userNotFoundInRejected) _rejectedMembers.add(user);

    bool userNotFoundInPending =
        _pendingMembers.every((existingUser) => user.id != existingUser.id);
    if (!userNotFoundInPending)
      _pendingMembers.removeWhere((existingUser) => user.id == existingUser.id);

    notifyListeners();
  }

  // void undoAcceptedRejectedMember(AppUser user) {
  //   _pendingMembers.add(user);
  //   if (_rejectedMembers.contains(user)) _rejectedMembers.remove(user);
  //   if (_acceptedMembers.contains(user)) _acceptedMembers.remove(user);
  //   notifyListeners();
  // }
}
