import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'constants/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/journey_provider.dart';
import 'providers/booking_provider.dart';

import 'screens/onboarding/welcome_screen.dart';
import 'screens/onboarding/login_screen.dart';
import 'screens/onboarding/register_screen.dart';
import 'screens/onboarding/preferences_screen.dart';

import 'screens/home/home_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/search/route_detail_screen.dart';

import 'screens/booking/stop_select_screen.dart';
import 'screens/booking/requesting_screen.dart';
import 'screens/booking/allocation_result_screen.dart';

import 'screens/journey/journey_screen.dart';
import 'screens/journey/incident_report_screen.dart';
import 'screens/journey/incident_submitted_screen.dart';

import 'screens/rating/rating_screen.dart';

import 'screens/profile/history_screen.dart';
import 'screens/profile/profile_screen.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/preferences', builder: (context, state) => const PreferencesScreen()),

    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(
      path: '/route/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'R_87';
        return RouteDetailScreen(routeId: id);
      },
    ),

    GoRoute(path: '/stop-select', builder: (context, state) => const StopSelectScreen()),
    GoRoute(path: '/requesting', builder: (context, state) => const RequestingScreen()),
    GoRoute(path: '/allocation', builder: (context, state) => const AllocationResultScreen()),

    GoRoute(path: '/journey', builder: (context, state) => const JourneyScreen()),
    GoRoute(
      path: '/incident',
      builder: (context, state) {
        final type = state.uri.queryParameters['type'];
        final severity = state.uri.queryParameters['severity'];
        return IncidentReportScreen(initialType: type, initialSeverity: severity);
      },
    ),
    GoRoute(path: '/submitted', builder: (context, state) => const IncidentSubmittedScreen()),

    GoRoute(path: '/rating', builder: (context, state) => const RatingScreen()),

    GoRoute(path: '/history', builder: (context, state) => const HistoryScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
  ],
);

class SafeBoardApp extends StatelessWidget {
  const SafeBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => JourneyProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp.router(
        title: 'SafeBoard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
