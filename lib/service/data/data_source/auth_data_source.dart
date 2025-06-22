import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../model/user_model.dart';

class AuthDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '574200276810-gq12rubde40vr908avhuul0n1n4r44n2.apps.googleusercontent.com',
  );

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount == null) {

    }
    final GoogleSignInAuthentication? googleSignInAuthentication =
    await googleSignInAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken,
    );
    final UserCredential result = await _auth.signInWithCredential(credential);
    return result.user;
  }

  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    final result = await TheAppleSignIn.performRequests(
      [AppleIdRequest(requestedScopes: scopes)],
    );
    if (result.status == AuthorizationStatus.authorized) {
      final appleIdCredential = result.credential!;
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: String.fromCharCodes(appleIdCredential.identityToken!),
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User firebaseUser = userCredential.user!;
      if (scopes.contains(Scope.fullName)) {
        final fullName = appleIdCredential.fullName;
        if (fullName != null && fullName.givenName != null && fullName.familyName != null) {
          await firebaseUser.updateDisplayName('${fullName.givenName} ${fullName.familyName}');
        }
      }
      return firebaseUser;
    }
    throw Exception('Apple Sign-In failed');
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(String email, String password, String name) async {
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user!.updateDisplayName(name);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> addUser(User user, {String? name}) async {
    final userInfoMap = UserModel(
      email: user.email ?? '',
      name: name ?? user.displayName,
      imgUrl: user.photoURL,
      id: user.uid,
    ).toMap();
    await _firestore.collection("User").doc(user.uid).set(userInfoMap);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}