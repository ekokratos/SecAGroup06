import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpad_assignment/models/user.dart';
import 'package:cpad_assignment/services/firebase_service.dart';
import 'package:cpad_assignment/utility/app_data.dart';

class UserService {
  static CollectionReference usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  static Future<AppUser> getUser() async {
    AppUser user;
    final String userId = FirebaseService.currentUserId!;
    try {
      final userDoc = await usersCollectionReference.doc(userId).get();
      user = AppUser.fromMap(userDoc.data() as Map<String, dynamic>);
      AppData.saveUser(user);
      AppData.setAdmin(user.isAdmin ?? false);
    } catch (e) {
      print('Error: $e');
      throw e;
    }
    return user;
  }

  static Future<void> createUser({required AppUser user}) async {
    Map<String, dynamic> data = user.toMap();
    try {
      await usersCollectionReference.doc(FirebaseService.currentUserId).set(
            data,
            SetOptions(
              merge: true,
            ),
          );
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<List<AppUser>> getAllUsers() async {
    List<AppUser> userList = [];
    try {
      final userDoc = await usersCollectionReference
          .where("isAdmin", isEqualTo: false)
          .get();

      userDoc.docs.forEach((doc) {
        final user = AppUser.fromMap(doc.data() as Map<String, dynamic>);
        userList.add(user);
      });
    } catch (e) {
      throw e;
    }
    return userList;
  }

  static Future<void> verifyUser(
      {required String userId, required bool isVerified}) async {
    try {
      await usersCollectionReference.doc(userId).set(
          {'isVerified': isVerified, 'isRejected': false},
          SetOptions(merge: true));
    } catch (e) {
      throw e;
    }
  }

  static Future<void> rejectUser(
      {required String userId, required bool isRejected}) async {
    try {
      await usersCollectionReference.doc(userId).set(
          {'isRejected': isRejected, 'isVerified': false},
          SetOptions(merge: true));
    } catch (e) {
      throw e;
    }
  }
}
