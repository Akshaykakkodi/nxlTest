import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/domain/auth/model/user_model.dart';
import 'package:test/domain/core/failures.dart';

abstract class IAuthFacade {
  // Returns the current user if authenticated, null otherwise
  User? getSignedInUser();

  // Stream of authentication state changes
  Stream<User?> get authStateChanges;

  // Sign in with email and password
  Future<Either<MainFailure, Unit>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  // Create a new user with email and password
  Future<Either<MainFailure, Unit>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  // Sign out the current user
  Future<void> signOut();

  Future<Either<MainFailure, UserModel>> getCurrentUser();
  Future<void> persistUserData(UserModel user);
  Future<void> clearUserData();
}
