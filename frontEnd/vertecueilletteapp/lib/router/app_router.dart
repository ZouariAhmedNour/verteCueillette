import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vertecueilletteapp/api/session_manager.dart';
import 'package:vertecueilletteapp/models/reservation_model.dart';
import 'package:vertecueilletteapp/screens/cart_screen.dart';
import 'package:vertecueilletteapp/screens/reservations_screen.dart';
import 'package:vertecueilletteapp/screens/edit_profile_screen.dart';
import 'package:vertecueilletteapp/screens/home_screen.dart';
import 'package:vertecueilletteapp/screens/reservation_success_screen.dart';
import 'package:vertecueilletteapp/screens/sign_in_screen.dart';
import 'package:vertecueilletteapp/screens/sign_up_screen.dart';
import 'package:vertecueilletteapp/theme/app_colors.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _cartNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'cart');
final _collectionsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'collections');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
     redirect: (context, state) {
      final loggedIn = SessionManager.token != null;
      final location = state.matchedLocation;
      final inAuth = location == '/sign-in' || location == '/sign-up';

      if (location == '/') {
        return loggedIn ? '/home' : '/sign-in';
      }

      if (!loggedIn && !inAuth) return '/sign-in';
      if (loggedIn && inAuth) return '/home';

      return null;
    },
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Route introuvable : ${state.uri}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    },

     routes: [
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _cartNavigatorKey,
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _collectionsNavigatorKey,
            routes: [
              GoRoute(
                path: '/collections',
                builder: (context, state) => const CollectionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const EditProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/reservation-success',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! ReservationModel) {
            return const _ReservationMissingScreen();
          }
          return ReservationSuccessScreen(reservation: extra);
        },
      ),
    ],
  );
});
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF97A4B8),
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Réservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _ReservationMissingScreen extends StatelessWidget {
  const _ReservationMissingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Réservation')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Impossible d’ouvrir cette réservation.\nLes données de navigation sont absentes.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/reservations'),
                child: const Text('Retour aux réservations'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}