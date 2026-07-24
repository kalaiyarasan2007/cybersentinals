import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_insight_ai/providers/providers.dart';
import 'package:student_insight_ai/screens/splash/splash_screen.dart';
import 'package:student_insight_ai/screens/onboarding/onboarding_screen.dart';
import 'package:student_insight_ai/screens/auth/login_screen.dart';
import 'package:student_insight_ai/screens/auth/signup_screen.dart';
import 'package:student_insight_ai/screens/auth/forgot_password_screen.dart';
import 'package:student_insight_ai/screens/home/home_screen.dart';
import 'package:student_insight_ai/screens/profile/edit_profile_screen.dart';
import 'package:student_insight_ai/screens/planner/pomodoro_screen.dart';
import 'package:student_insight_ai/screens/planner/habit_tracker_screen.dart';
import 'package:student_insight_ai/screens/profile/settings_screen.dart';
import 'package:student_insight_ai/screens/analytics/placement_screen.dart';
import 'package:student_insight_ai/screens/analytics/mock_interview_screen.dart';
import 'package:student_insight_ai/screens/profile/notifications_screen.dart';
import 'package:student_insight_ai/screens/timetable/timetable_screen.dart';
import 'package:student_insight_ai/screens/calendar/calendar_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuth = isLoggedIn;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation == '/splash' ||
          state.matchedLocation == '/onboarding';

      if (!isAuth && !isAuthRoute) return '/login';
      if (isAuth && state.matchedLocation == '/login') return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
      GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/edit-profile', builder: (_, __) => const EditProfileScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/pomodoro', builder: (_, __) => const PomodoroScreen()),
      GoRoute(path: '/habit-tracker', builder: (_, __) => const HabitTrackerScreen()),
      GoRoute(path: '/placement', builder: (_, __) => const PlacementScreen()),
      GoRoute(path: '/mock-interview', builder: (_, __) => const MockInterviewScreen()),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/timetable', builder: (_, __) => const TimetableScreen()),
      GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
    ],
  );
});
