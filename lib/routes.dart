import 'package:go_router/go_router.dart';
import 'package:reading/achievements/presentation/screens/achivements_screen.dart';
import 'package:reading/authentication/presentation/screens/login_screen.dart';
import 'package:reading/authentication/presentation/screens/signup_screen.dart';
import 'package:reading/books/presentation/screens/book_details_screen.dart';
import 'package:reading/books/presentation/screens/new_book_screen.dart';
import 'package:reading/classes/presentation/screens/classes_screen.dart';
import 'package:reading/classes/presentation/screens/join_class_screen.dart';
import 'package:reading/intro/data/repositories/intro_repository.dart';
import 'package:reading/intro/presentation/screens/intro_screen.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:reading/profile/presentation/screens/profile_screen.dart';
import 'package:reading/shared/presentation/screens/home_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes.g.dart';

@riverpod
Raw<GoRouter> router(RouterRef ref) {
  return GoRouter(
    initialLocation: ref.read(introSeenProvider).value! ? null : '/intro',
    routes: [
      GoRoute(
        builder: (context, state) => const HomeScreen(),
        path: '/',
        redirect: (context, state) {
          final profile = ref.read(profileProvider).valueOrNull;

          return profile == null //
              ? '/login'
              : null;
        },
        routes: [
          GoRoute(
            path: 'book',
            builder: (context, state) => BookDetailsScreen(
              bookId: state.extra! as int,
            ),
          ),
          GoRoute(
            path: 'book/new',
            builder: (context, state) => const NewBookScreen(),
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
            path: 'achievements',
            builder: (context, state) => const AchivementsScreen(),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
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
