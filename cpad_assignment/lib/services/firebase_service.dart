import 'package:cpad_assignment/models/user.dart';
import 'package:cpad_assignment/services/user_service.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  /// Signs in with the provided [email] and [password].
  static Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((user) async {
        print('User: ${user.user}');
      });
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      print('Code: ${e.code}');
      if (e.code == 'user-not-found') {
        throw FormatException('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw FormatException('Wrong password.');
      } else {
        throw FormatException('Something went wrong. Please try later.');
      }
    }
  }

  static Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required AppUser appUser,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((user) async {
        print('User: ${user.user}');
        appUser.id = user.user!.uid;
        await UserService.createUser(user: appUser);
      });
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      print('Code: ${e.code}');
      if (e.code == 'email-already-in-use') {
        throw FormatException('User already exists');
      } else {
        throw FormatException('Something went wrong. Please try later.');
      }
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut().then((_) => AppData.clearSP());
  }
}
