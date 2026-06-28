import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xtacy_backoffice/core/constants/app_constants.dart';
import 'package:xtacy_backoffice/core/theme/app_theme.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_state.dart';
import 'package:xtacy_backoffice/presentation/widgets/confirm_dialog.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go('/home');
          }
          if (state.errorMessage != null) {
            showAppSnackBar(context, state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.carbonBlue,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your store inventory and sales',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.carbonGray50,
                        ),
                  ),
                  const SizedBox(height: 48),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.store_outlined,
                            size: 64,
                            color: AppTheme.carbonBlue,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Sign in to continue',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Use your Google account to access the store inventory',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.carbonGray50,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: state.isLoading
                                  ? null
                                  : () => context
                                      .read<AuthBloc>()
                                      .add(const AuthGoogleSignInRequested()),
                              icon: state.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.login),
                              label: Text(
                                state.isLoading
                                    ? 'Signing in...'
                                    : 'Sign in with Google',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
