import 'package:equatable/equatable.dart';
import 'package:xtacy_backoffice/data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final UserModel? user;

  @override
  List<Object?> get props => [user];
}
