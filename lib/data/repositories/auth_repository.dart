import 'package:xtacy_backoffice/data/models/user_model.dart';
import 'package:xtacy_backoffice/data/services/firebase_auth_service.dart';
import 'package:xtacy_backoffice/data/services/firestore_service.dart';

/// Repository for authentication operations.
class AuthRepository {
  AuthRepository({
    FirebaseAuthService? authService,
    FirestoreService? firestoreService,
  })  : _authService = authService ?? FirebaseAuthService(),
        _firestoreService = firestoreService ?? FirestoreService();

  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  Stream<dynamic> get authStateChanges => _authService.authStateChanges;

  UserModel? get currentUser {
    final user = _authService.currentUser;
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? 'User',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
  }

  Future<UserModel> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    try {
      await _firestoreService.saveUser(
        uid: user.uid,
        name: user.name,
        email: user.email,
        photoUrl: user.photoUrl,
      );
    } catch (_) {
      // Sign-in already succeeded; profile sync can retry later.
    }
    return user;
  }

  Future<void> signOut() => _authService.signOut();
}
