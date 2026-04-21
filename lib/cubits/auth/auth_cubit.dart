import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_app/cubits/auth/auth_state.dart';
import 'package:recipe_app/models/user_model.dart';
import 'package:recipe_app/repo/user_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserRepository _userRepository = UserRepository();

  AuthCubit() : super(AuthInitial());

  // ─── Check Auth Status ─────────────────────────────────
  void checkAuthStatus() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  // ─── Sign Up ───────────────────────────────────────────
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      // 1. Create user in Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user!;

      // 2. Save user data in Firestore
      await _userRepository.saveUser(
        UserModel(
          uid: user.uid,
          name: name.trim(),
          email: email.trim(),
          phone: user.phoneNumber ?? '',
          createdAt: DateTime.now(),
        ),
      );

      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      emit(AuthFailure('Unexpected error. Please try again.'));
    }
  }

  // ─── Login ─────────────────────────────────────────────
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      emit(AuthSuccess(credential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      emit(AuthFailure('Unexpected error. Please try again.'));
    }
  }

  // ─── Google Sign In ────────────────────────────────────
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthInitial());
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // ✅ Check if user already exists in Firestore
      final exists = await _userRepository.userExists(user.uid);

      // Only save if it's the first time (new user)
      if (!exists) {
        await _userRepository.saveUser(
          UserModel(
            uid: user.uid,
            name: user.displayName ?? 'No Name',
            email: user.email ?? '',
            phone: user.phoneNumber ?? '',
            createdAt: DateTime.now(),
          ),
        );
      }

      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      emit(AuthFailure('Google Sign-In failed. Please try again.'));
    }
  }

  // ─── Logout ────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    emit(AuthUnauthenticated());
  }

  // ─── Error Mapper ──────────────────────────────────────
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
