import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xtacy_backoffice/data/models/product_model.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_state.dart';
import 'package:xtacy_backoffice/presentation/blocs/product_form/product_form_bloc.dart';
import 'package:xtacy_backoffice/presentation/screens/login_screen.dart';
import 'package:xtacy_backoffice/presentation/screens/main_shell.dart';
import 'package:xtacy_backoffice/presentation/screens/product_details_screen.dart';
import 'package:xtacy_backoffice/presentation/screens/product_form_screen.dart';
import 'package:xtacy_backoffice/presentation/screens/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/';

      if (authState.status == AuthStatus.unknown && !isSplash) {
        return '/';
      }

      if (!isAuthenticated && !isLoggingIn && !isSplash) {
        return '/login';
      }

      if (isAuthenticated && (isLoggingIn || isSplash)) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainShell(),
      ),
      GoRoute(
        path: '/products/add',
        builder: (context, state) => BlocProvider(
          create: (_) => ProductFormBloc(),
          child: const AddProductScreen(),
        ),
      ),
      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailsScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/products/:id/edit',
        builder: (context, state) {
          final product = state.extra as ProductModel;
          return BlocProvider(
            create: (_) => ProductFormBloc(),
            child: EditProductScreen(product: product),
          );
        },
      ),
    ],
  );
}
