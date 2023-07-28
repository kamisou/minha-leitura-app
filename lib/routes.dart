import 'package:go_router/go_router.dart';
import 'package:reading/achievements/presentation/screens/achievements_screen.dart';
import 'package:reading/authentication/data/repositories/auth_repository.dart';
import 'package:reading/authentication/presentation/screens/login_screen.dart';
import 'package:reading/authentication/presentation/screens/signup_screen.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/presentation/screens/book_details_screen.dart';
import 'package:reading/classes/presentation/screens/classes_screen.dart';
import 'package:reading/classes/presentation/screens/join_class_screen.dart';
import 'package:reading/intro/data/repositories/intro_repository.dart';
import 'package:reading/intro/presentation/screens/intro_screen.dart';
import 'package:reading/profile/presentation/screens/my_profile_screen.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/presentation/screens/home_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes.g.dart';

@riverpod
Raw<GoRouter> router(RouterRef ref) {
  final introSeen = ref.read(introSeenProvider).requireValue;

  return GoRouter(
    initialLocation: introSeen ? null : '/intro',
    routes: [
      GoRoute(
        builder: (context, state) => const HomeScreen(),
        path: '/',
        redirect: (context, state) =>
            ref.read(isConnectedProvider) && ref.read(userProvider) == null
                ? '/login'
                : null,
        routes: [
          GoRoute(
            path: 'achievements',
            builder: (context, state) => const AchievementsScreen(),
          ),
          GoRoute(
            path: 'book',
            builder: (context, state) => BookDetailsScreen(
              book: state.extra! as Book,
            ),
          ),
          GoRoute(
            path: 'classes',
            builder: (context, state) => const ClassesScreen(),
            routes: [
              GoRoute(
                path: 'join',
                builder: (context, state) => const JoinClassScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/myProfile',
            builder: (context, state) => const MyProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/intro',
        builder: (context, state) => const IntroScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
    ],
  );
}
