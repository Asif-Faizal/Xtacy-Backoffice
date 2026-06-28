import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:xtacy_backoffice/core/errors/failures.dart';
import 'package:xtacy_backoffice/data/models/user_model.dart';

/// Handles Firebase Authentication with Google Sign In.
class FirebaseAuthService {
  FirebaseAuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthFailure('Sign in cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        throw const AuthFailure('Failed to sign in');
      }

      return UserModel(
        uid: user.uid,
        name: user.displayName ?? 'User',
        email: user.email ?? '',
        photoUrl: user.photoURL,
      );
    } on AuthFailure {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Authentication failed');
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Sign out failed');
    }
  }
}
