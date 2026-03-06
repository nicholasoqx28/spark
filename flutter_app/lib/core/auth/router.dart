import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/tournaments/screens/tournaments_screen.dart';
import '../../features/shop/screens/shop_screen.dart';
import '../../features/academy/screens/academy_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isAuth = auth.isAuthenticated;
      final isLoading = auth.isLoading;
      final path = state.matchedLocation;

      if (isLoading) return null;

      final publicPaths = ['/login', '/register'];
      if (!isAuth && !publicPaths.contains(path)) return '/login';
      if (isAuth && publicPaths.contains(path)) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
      GoRoute(path: '/tournaments', builder: (_, __) => const TournamentsScreen()),
      GoRoute(path: '/shop', builder: (_, __) => const ShopScreen()),
      GoRoute(path: '/academy', builder: (_, __) => const AcademyScreen()),
    ],
  );
});
