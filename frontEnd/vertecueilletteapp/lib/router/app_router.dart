



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vertecueilletteapp/screens/edit_profile_screen.dart';
import 'package:vertecueilletteapp/screens/home_screen.dart';
import 'package:vertecueilletteapp/screens/sign_in_screen.dart';
import 'package:vertecueilletteapp/screens/sign_up_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/sign-in',
    routes: [
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );
});