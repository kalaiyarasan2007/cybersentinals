import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/providers/providers.dart';
import 'package:student_insight_ai/screens/dashboard/dashboard_screen.dart';
import 'package:student_insight_ai/screens/analytics/analytics_screen.dart';
import 'package:student_insight_ai/screens/ai_assistant/ai_assistant_screen.dart';
import 'package:student_insight_ai/screens/timetable/timetable_screen.dart';
import 'package:student_insight_ai/screens/calendar/calendar_screen.dart';
import 'package:student_insight_ai/screens/profile/profile_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);
    final isDark = ref.watch(themeProvider);

    final screens = const [
      DashboardScreen(),
      AnalyticsScreen(),
      AIAssistantScreen(),
      TimetableScreen(),
      CalendarScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.dashboard_rounded, label: 'Home', index: 0, currentIndex: index),
                _NavItem(icon: Icons.bar_chart_rounded, label: 'Analytics', index: 1, currentIndex: index),
                _NavItem(icon: Icons.psychology_rounded, label: 'AI', index: 2, currentIndex: index, isCenter: true),
                _NavItem(icon: Icons.table_chart_rounded, label: 'Timetable', index: 3, currentIndex: index),
                _NavItem(icon: Icons.calendar_month_rounded, label: 'Calendar', index: 4, currentIndex: index),
                _NavItem(icon: Icons.person_rounded, label: 'Profile', index: 5, currentIndex: index),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends ConsumerWidget {
  final IconData icon;
  final String label;
  final int index, currentIndex;
  final bool isCenter;

  const _NavItem({required this.icon, required this.label, required this.index, required this.currentIndex, this.isCenter = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final isSelected = index == currentIndex;

    if (isCenter) {
      return GestureDetector(
        onTap: () => ref.read(navIndexProvider.notifier).state = index,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 52, height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSelected
                  ? [const Color(0xFF1A73E8), const Color(0xFF4285F4)]
                  : [const Color(0xFF1A73E8).withValues(alpha: 0.8), const Color(0xFF4285F4).withValues(alpha: 0.8)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      );
    }

    return GestureDetector(
      onTap: () => ref.read(navIndexProvider.notifier).state = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isSelected ? AppTheme.primaryBlue : (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                size: 22),
            const SizedBox(height: 3),
            Text(label,
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppTheme.primaryBlue : (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                )),
          ],
        ),
      ),
    );
  }
}
