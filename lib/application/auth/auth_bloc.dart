import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';
import 'package:test/application/core/utils/app_details.dart';
import 'package:test/application/core/utils/enums.dart';
import 'package:test/domain/auth/i_auth_facade.dart';
import 'package:test/presentation/auth/login_screen.dart';

import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;
  late final StreamSubscription<User?> _authSubscription;

  AuthBloc(this._authFacade) : super(const AuthState()) {
    // Set up auth state changes subscription
    _authSubscription = _authFacade.authStateChanges.listen((user) {
      if (user != null) {
        add(AuthCheckRequested());
      } else {
        emit(state.copyWith(authState: ApiState.failure, user: null));
      }
    });

    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);
    on<SignUpWithEmailAndPassword>(_onSignUpWithEmailAndPassword);
    on<SignOut>(_onSignOut);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _authFacade.getSignedInUser();
    if (user != null) {
      emit(
        state.copyWith(
          authState: ApiState.failure,
          user: user,
          errorMessage: null,
        ),
      );
    } else {
      emit(state.copyWith(authState: ApiState.failure, user: null));
    }
  }

  Future<void> _onSignInWithEmailAndPassword(
    SignInWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(authState: ApiState.loading));

    final result = await _authFacade.signInWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          authState: ApiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          authState: ApiState.success,
          user: _authFacade.getSignedInUser(),
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onSignUpWithEmailAndPassword(
    SignUpWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(authState: ApiState.loading));

    final result = await _authFacade.signUpWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          authState: ApiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          authState: ApiState.success,
          user: _authFacade.getSignedInUser(),
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    await _authFacade.signOut();
    emit(state.copyWith(authState: ApiState.failure, user: null));
    Fluttertoast.showToast(msg: "Logged Out!");
    Navigator.push(
      AppDetails.globalNavigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
