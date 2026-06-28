import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xtacy_backoffice/core/constants/app_constants.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_state.dart';
import 'package:xtacy_backoffice/presentation/widgets/confirm_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state.user;
          if (user == null) {
            return const Center(child: Text('Not signed in'));
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                          style: const TextStyle(fontSize: 32),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.store_outlined),
                    title: const Text('Store'),
                    subtitle: Text(AppConstants.defaultMerchantName),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirmed = await showConfirmDialog(
                        context: context,
                        title: 'Sign Out',
                        message: 'Are you sure you want to sign out?',
                        confirmText: 'Sign Out',
                        isDestructive: true,
                      );
                      if (confirmed == true) {
                        context.read<AuthBloc>().add(const AuthSignOutRequested());
                        context.go('/login');
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
