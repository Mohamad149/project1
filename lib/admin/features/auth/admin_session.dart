import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AdminAccessException implements Exception {
  final String message;
  const AdminAccessException(this.message);

  @override
  String toString() => message;
}

class AdminSession extends ChangeNotifier {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AdminSession({
    required this.auth,
    required this.firestore,
  });

  bool _initialized = false;
  bool _busy = false;
  bool _isAdmin = false;
  User? _user;
  String? _errorMessage;

  bool get initialized => _initialized;
  bool get busy => _busy;
  bool get isAdmin => _isAdmin;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _busy = true;
    notifyListeners();

    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        _user = null;
        _isAdmin = false;
      } else {
        final admin = await _hasAdminRole(currentUser.uid);
        if (admin) {
          _user = currentUser;
          _isAdmin = true;
        } else {
          await auth.signOut();
          _user = null;
          _isAdmin = false;
        }
      }
    } catch (_) {
      _user = null;
      _isAdmin = false;
    } finally {
      _initialized = true;
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _busy = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final signedInUser = credential.user;
      if (signedInUser == null) {
        throw const AdminAccessException('Could not sign in.');
      }

      final admin = await _hasAdminRole(signedInUser.uid);
      if (!admin) {
        await auth.signOut();
        throw const AdminAccessException(
          'This account does not have admin access.',
        );
      }

      _user = signedInUser;
      _isAdmin = true;
    } on FirebaseAuthException catch (error) {
      _errorMessage = _firebaseMessage(error);
      rethrow;
    } on AdminAccessException catch (error) {
      _errorMessage = error.message;
      rethrow;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      rethrow;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _busy = true;
    notifyListeners();

    try {
      await auth.signOut();
      _user = null;
      _isAdmin = false;
      _errorMessage = null;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<bool> _hasAdminRole(String uid) async {
    final document = await firestore.collection('users').doc(uid).get();
    final data = document.data();
    return data != null && data['role'] == 'admin';
  }

  String _firebaseMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'Check your internet connection.';
      default:
        return error.message ?? 'Login failed.';
    }
  }
}
