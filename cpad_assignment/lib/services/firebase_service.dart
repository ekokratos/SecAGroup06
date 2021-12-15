import 'package:cpad_assignment/models/user.dart';
import 'package:cpad_assignment/services/user_service.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  static Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String errCode = e.code;
      if (errCode == 'invalid-email') {
        throw FormatException('Invalid email');
      } else if (errCode == 'user-not-found') {
        throw FormatException('User not Found.');
      }
    }
  }

  static Future<void> signOut() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut().then((_) => AppData.clearSP());
    } catch (e) {
      print(e);
    }
  }

  static Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
          print('User: $user');

          await UserService.addGoogleUser(user: user!);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            throw FormatException(
                'Account already exists with a different credential.');
          } else if (e.code == 'invalid-credential') {
            throw FormatException('Invalid credential');
          }
        } catch (e) {
          throw FormatException('Something went wrong. Please try again.');
        }
      }
    }

    return user;
  }
}
