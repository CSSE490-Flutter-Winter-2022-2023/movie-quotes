import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthManager {
  AuthManager._privateConstructor();
  static final AuthManager instance = AuthManager._privateConstructor();

  final Map<UniqueKey, Function> _loginObservers = {};
  final Map<UniqueKey, Function> _logoutObservers = {};

  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  StreamSubscription<User?>? _subscription;

  void beginListening() {
    if (_subscription != null) {
      return; // Already listening, ignore future calls.
    }
    _auth = FirebaseAuth.instance;
    _subscription = _auth.authStateChanges().listen((User? user) {
      // Necessary to avoid unexpected double calls.
      final isLogin = _user == null && user != null;
      final isLogout = _user != null && user == null;
      _user = user;
      if (isLogin) {
        notifyLoginObservers();
      } else if (isLogout) {
        notifyLogoutObservers();
      }
    });
  }

  // Never called.
  void endListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  UniqueKey addLoginObserver(Function observer) {
    beginListening(); // Just in case.  No harm if already listening.
    UniqueKey key = UniqueKey();
    _loginObservers[key] = observer;
    return key;
  }

  UniqueKey addLogoutObserver(Function observer) {
    UniqueKey key = UniqueKey();
    _logoutObservers[key] = observer;
    return key;
  }

  void removeLoginObserver(UniqueKey? observerKey) {
    _loginObservers.remove(observerKey);
  }

  void removeLogoutObserver(UniqueKey? observerKey) {
    _logoutObservers.remove(observerKey);
  }

  void removeAllLoginObservers() {
    _loginObservers.clear();
  }

  void removeAllLogoutObservers() {
    _logoutObservers.clear();
  }

  void notifyLoginObservers() {
    for (Function observer in _loginObservers.values) {
      observer();
    }
  }

  void notifyLogoutObservers() {
    for (Function observer in _logoutObservers.values) {
      observer();
    }
  }

  void createUserWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // print("Attempting to create a user!");
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Created user ${credential.user?.email}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // I don't think this path is possible.
        _showAuthError(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        _showAuthError(context, "The account already exists for that email.");
      }
    } catch (e) {
      _showAuthError(context, e.toString());
    }
  }

  void signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("Signed in user ${credential.user?.email}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showAuthError(context, "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        _showAuthError(context, "Wrong password provided for that user.");
      }
    }
  }

  void _showAuthError(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(message),
      ),
    );
  }

  void signOut() {
    _auth.signOut();
  }

  String get uid => _user?.uid ?? "";
  String get email => _user?.email ?? "";
  bool get isSignedIn => _user != null;
}
