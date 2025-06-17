import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../home_widigts/home.dart';
import 'database.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Get current user
  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  // Sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn(
        // Specify clientId if needed for Android (optional, remove if using default)
        clientId: '574200276810-gq12rubde40vr908avhuul0n1n4r44n2.apps.googleusercontent.com',
      );

      // Trigger Google Sign-In
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // User canceled the sign-in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Google Sign-In canceled",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
        return;
      }

      final GoogleSignInAuthentication? googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken,
      );

      UserCredential result = await firebaseAuth.signInWithCredential(credential);
      User? userDetails = result.user;

      if (userDetails != null) {
        Map<String, dynamic> userInfoMap = {
          "email": userDetails.email,
          "name": userDetails.displayName,
          "imgUrl": userDetails.photoURL,
          "id": userDetails.uid,
        };

        await DatabaseMethods().addUser(userDetails.uid, userInfoMap);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to sign in with Google",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error during Google Sign-In: $e",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }

  // Sign in with Apple
  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    try {
      final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)],
      );

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          );
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);
          final firebaseUser = userCredential.user!;

          if (scopes.contains(Scope.fullName)) {
            final fullName = appleIdCredential.fullName;
            if (fullName != null &&
                fullName.givenName != null &&
                fullName.familyName != null) {
              final displayName = '${fullName.givenName} ${fullName.familyName}';
              await firebaseUser.updateDisplayName(displayName);
            }
          }
          return firebaseUser;

        case AuthorizationStatus.error:
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString(),
          );

        case AuthorizationStatus.cancelled:
          throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );

        default:
          throw UnimplementedError();
      }
    } catch (e) {
      throw Exception('Apple Sign-In failed: $e');
    }
  }
}