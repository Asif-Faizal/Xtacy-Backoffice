import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xtacy_backoffice/core/constants/app_constants.dart';
import 'package:xtacy_backoffice/core/theme/app_theme.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthCheckRequested());
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final state = context.read<AuthBloc>().state;
      if (state.status == AuthStatus.authenticated) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.carbonGray100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Inventory & Sales Management',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.carbonGray50,
                  ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: AppTheme.carbonBlue),
          ],
        ),
      ),
    );
  }
}
