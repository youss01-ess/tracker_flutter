import 'package:go_router/go_router.dart';
import 'package:tracker_flutter/presentation/auth.dart';
import 'package:tracker_flutter/presentation/home.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const Authentication(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Home(),
    ),
  ],
);
