import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../authentication/data/repositories/auth_repository.dart';
import '../authentication/presentation/screens/login_screen.dart';
import '../shared/presentation/screens/home_screen.dart';

part 'router.g.dart';

@riverpod
Raw<GoRouter> router(RouterRef ref) {
  return GoRouter(
    redirect: (context, state) {
      final user = ref.read(authRepositoryProvider).requireValue;

      if (user == null) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
