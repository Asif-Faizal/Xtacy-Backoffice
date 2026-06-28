import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtacy_backoffice/core/routes/app_router.dart';
import 'package:xtacy_backoffice/core/theme/app_theme.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/inventory_filter/inventory_filter_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/product/product_bloc.dart';

class XtacyApp extends StatelessWidget {
  const XtacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => ProductBloc()),
        BlocProvider(create: (_) => DashboardBloc()),
        BlocProvider(create: (_) => InventoryFilterBloc()),
      ],
      child: MaterialApp.router(
        title: 'Xtacy Backoffice',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
