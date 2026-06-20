import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/name_record.dart';
import '../features/favorites/views/favorites_screen.dart';
import '../features/names/views/name_detail_screen.dart';
import '../features/names/views/main_swipe_screen.dart';
import '../features/profile/views/initial_name_form.dart';
import '../features/settings/views/settings_screen.dart';

GoRouter createRouter({List<NavigatorObserver> observers = const []}) {
  return GoRouter(
    initialLocation: '/',
    observers: observers,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MainSwipeScreen(),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/details',
        name: 'details',
        pageBuilder: (context, state) {
          final name = state.extra;
          final child = name is NameRecord
              ? NameDetailScreen(name: name)
              : const MainSwipeScreen();

          return CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 320),
            reverseTransitionDuration: const Duration(milliseconds: 240),
            child: child,
            transitionsBuilder: (_, animation, _, child) {
              final offsetAnimation = animation.drive(
                Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeOutCubic)),
              );

              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const InitialNameForm(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
