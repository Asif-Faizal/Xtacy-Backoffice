import 'package:equatable/equatable.dart';
import 'package:xtacy_backoffice/data/models/user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;
  final bool isLoading;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
    bool? isLoading,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, isLoading];
}
