import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../models/user.dart';
import 'interfaces/auth_service_interface.dart';

/// Firebase-backed implementation of [IAuthService]
/// Uses Firebase Auth for authentication and Firestore for user profile data
class FirebaseAuthService implements IAuthService {
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final _authStateController = StreamController<User?>.broadcast();
  
  User? _currentUser;
  StreamSubscription<fb.User?>? _firebaseAuthSubscription;

  FirebaseAuthService({
    fb.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    // Listen to Firebase auth state changes and map to our User model
    _firebaseAuthSubscription = _firebaseAuth.authStateChanges().listen(
      _handleFirebaseAuthStateChange,
    );
    // Initialize with current Firebase user
    _initCurrentUser();
  }

  Future<void> _initCurrentUser() async {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser != null) {
      _currentUser = await _mapFirebaseUser(fbUser);
      _authStateController.add(_currentUser);
    }
  }

  Future<void> _handleFirebaseAuthStateChange(fb.User? fbUser) async {
    if (fbUser != null) {
      _currentUser = await _mapFirebaseUser(fbUser);
    } else {
      _currentUser = null;
    }
    _authStateController.add(_currentUser);
  }

  /// Map Firebase user + Firestore profile to our User model
  Future<User> _mapFirebaseUser(fb.User fbUser) async {
    // Try to get additional user data from Firestore
    final doc = await _firestore.collection('users').doc(fbUser.uid).get();
    final data = doc.data();

    return User(
      id: fbUser.uid,
      name: data?['name'] ?? fbUser.displayName ?? 'User',
      email: fbUser.email ?? '',
      role: _parseRole(data?['role']),
      createdAt: data?['createdAt'] != null
          ? (data!['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  UserRole _parseRole(String? role) {
    if (role == 'admin') return UserRole.admin;
    return UserRole.user;
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  User? get currentUser => _currentUser;

  @override
  bool get isLoggedIn => _currentUser != null;

  @override
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        _currentUser = await _mapFirebaseUser(credential.user!);
        return AuthResult.success(_currentUser!);
      }
      return AuthResult.failure('Login failed. Please try again.');
    } on fb.FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapFirebaseAuthError(e.code));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred.');
    }
  }

  @override
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Validate inputs
    if (name.trim().isEmpty) {
      return AuthResult.failure('Name is required.');
    }
    if (password.length < AppConfig.minPasswordLength) {
      return AuthResult.failure(
        'Password must be at least ${AppConfig.minPasswordLength} characters.',
      );
    }

    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(name.trim());

        // Create Firestore user profile
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });

        _currentUser = User(
          id: credential.user!.uid,
          name: name.trim(),
          email: email.trim().toLowerCase(),
          role: UserRole.user,
          createdAt: DateTime.now(),
        );

        return AuthResult.success(_currentUser!);
      }
      return AuthResult.failure('Registration failed. Please try again.');
    } on fb.FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      return AuthResult.failure(_mapFirebaseAuthError(e.code));
    } catch (e) {
      debugPrint('Unexpected registration error: $e');
      return AuthResult.failure('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }

  @override
  void dispose() {
    _firebaseAuthSubscription?.cancel();
    _authStateController.close();
  }

  /// Map Firebase Auth error codes to user-friendly messages
  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email. Please register.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'email-already-in-use':
        return 'This email is already registered. Please login.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
