import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:test/domain/auth/i_auth_facade.dart';
import 'package:test/domain/auth/model/user_model.dart';
import 'package:test/domain/core/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: IAuthFacade)
class AuthFacadeImpl implements IAuthFacade {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final SharedPreferences _prefs;

  AuthFacadeImpl(this._prefs);

  @override
  User? getSignedInUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<Either<MainFailure, Unit>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final user = UserModel.fromFirebaseUser(userCredential.user!);
        await persistUserData(user);
      }
      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return left(const MainFailure(message: 'Invalid email or password'));
      } else {
        return left(MainFailure(message: e.message ?? 'Authentication failed'));
      }
    } catch (e) {
      return left(MainFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<MainFailure, Unit>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final user = UserModel.fromFirebaseUser(userCredential.user!);
        await persistUserData(user);
      }
      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left(
          const MainFailure(message: 'The password provided is too weak.'),
        );
      } else if (e.code == 'email-already-in-use') {
        return left(
          const MainFailure(
            message: 'An account already exists for that email.',
          ),
        );
      } else {
        return left(MainFailure(message: e.message ?? 'Registration failed'));
      }
    } catch (e) {
      return left(MainFailure(message: e.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await clearUserData();
  }

  @override
  Future<Either<MainFailure, UserModel>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        final userJson = _prefs.getString('current_user');
        if (userJson != null) {
          return right(UserModel.fromJson(jsonDecode(userJson)));
        }
        return left(const MainFailure(message: 'No user logged in'));
      }
      return right(UserModel.fromFirebaseUser(user));
    } catch (e) {
      return left(MainFailure(message: 'Failed to get user: ${e.toString()}'));
    }
  }

  @override
  Future<void> persistUserData(UserModel user) async {
    await _prefs.setString('current_user', jsonEncode(user.toJson()));
    await _prefs.setBool('is_logged_in', true);
  }

  @override
  Future<void> clearUserData() async {
    await _prefs.remove('current_user');
    await _prefs.setBool('is_logged_in', false);
  }
}
