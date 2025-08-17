import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/compose_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/post_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (_, __) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'compose',
            builder: (_, __) => const ComposeScreen(),
          ),
          GoRoute(
            path: 'profile/:uid',
            builder: (ctx, state) => ProfileScreen(uid: state.pathParameters['uid']!),
          ),
          GoRoute(
            path: 'post/:id',
            builder: (ctx, state) => PostDetailScreen(postId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'search',
            builder: (_, __) => const SearchScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (_, __) => const Scaffold(body: Center(child: Text('Not found'))),
  );
}
