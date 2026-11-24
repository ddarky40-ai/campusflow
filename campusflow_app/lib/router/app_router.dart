import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_status.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/task_detail_screen.dart';
import '../screens/task_form_screen.dart';
import '../screens/courses_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/register_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/login',
    refreshListenable: authStatus,
    redirect: (context, state) {
      final authenticated = authStatus.value;
      final isLogin = state.matchedLocation == '/login';
      final isRegistration =
          state.matchedLocation == '/inscription';

      if (!authenticated && !isLogin && !isRegistration) return '/login';
      if (authenticated && (isLogin || isRegistration)) return '/taches';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/inscription',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          int currentIndex = 0;
          if (state.matchedLocation.startsWith('/cours')) currentIndex = 1;
          if (state.matchedLocation.startsWith('/profil')) currentIndex = 2;

          return Scaffold(
            body: child,
            bottomNavigationBar: NavigationBar(
              height: 72,
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    context.go('/taches');
                    break;
                  case 1:
                    context.go('/cours');
                    break;
                  case 2:
                    context.go('/profil');
                    break;
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.assignment_outlined),
                  selectedIcon: Icon(Icons.assignment),
                  label: 'Échéances',
                ),
                NavigationDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book),
                  label: 'Cours',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/taches',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/cours',
            builder: (context, state) => const CoursesScreen(),
          ),
          GoRoute(
            path: '/profil',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/taches/nouvelle',
        builder: (context, state) => const TaskFormScreen(),
      ),
      GoRoute(
        path: '/taches/:id',
        builder: (context, state) =>
            TaskDetailScreen(taskId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/task/new',
        redirect: (context, state) => '/taches/nouvelle',
      ),
      GoRoute(
        path: '/task/:id',
        redirect: (context, state) =>
            '/taches/${state.pathParameters['id']}',
      ),
      GoRoute(
        path: '/',
        redirect: (context, state) => '/taches',
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
