import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtacy_backoffice/data/models/user_model.dart';
import 'package:xtacy_backoffice/data/repositories/auth_repository.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const AuthState()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignIn);
    on<AuthSignOutRequested>(_onSignOut);
    on<AuthUserChanged>(_onUserChanged);

    _authSubscription = _authRepository.authStateChanges.listen((firebaseUser) {
      if (firebaseUser != null) {
        add(AuthUserChanged(UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'User',
          email: firebaseUser.email ?? '',
          photoUrl: firebaseUser.photoURL,
        )));
      } else {
        add(const AuthUserChanged(null));
      }
    });
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<dynamic> _authSubscription;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } else {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
      ));
    }
  }

  Future<void> _onGoogleSignIn(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final user = await _authRepository.signInWithGoogle();
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('AuthFailure: ', ''),
      ));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _authRepository.signOut();
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('AuthFailure: ', ''),
      ));
    }
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: event.user,
      ));
    } else {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
      ));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
