import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: CampusFlowApp()));
}

class CampusFlowApp extends ConsumerStatefulWidget {
  const CampusFlowApp({super.key});

  @override
  ConsumerState<CampusFlowApp> createState() => _CampusFlowAppState();
}

class _CampusFlowAppState extends ConsumerState<CampusFlowApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await ref.read(authProvider.notifier).initialize();

    if (mounted) {
      setState(() => _initialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
