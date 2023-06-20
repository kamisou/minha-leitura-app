import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../authentication/data/repositories/auth_repository.dart';
import '../authentication/presentation/screens/login_screen.dart';
import '../profile/presentation/screens/profile_screen.dart';
import '../shared/presentation/screens/home_screen.dart';

part 'router.g.dart';

@riverpod
Raw<GoRouter> router(RouterRef ref) {
  return GoRouter(
    redirect: (context, state) async {
      final user = ref.read(authRepositoryProvider).valueOrNull;

      if (user == null) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
