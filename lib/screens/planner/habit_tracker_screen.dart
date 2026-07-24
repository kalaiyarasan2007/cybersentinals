import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/core/models/models.dart';
import 'package:student_insight_ai/providers/providers.dart';

class HabitTrackerScreen extends ConsumerWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final habits = ref.watch(habitsProvider);
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context), color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
        backgroundColor: Colors.transparent,
        title: Text('Habit Tracker', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              icon: const Icon(Icons.add, color: AppTheme.primaryBlue, size: 18),
              label: Text('Add', style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Summary
          Row(children: [
            _HabitStat(title: 'Active Habits', value: '${habits.length}', color: AppTheme.primaryBlue, isDark: isDark),
            const SizedBox(width: 12),
            _HabitStat(title: 'Best Streak', value: '${habits.map((h) => h.bestStreak).reduce((a, b) => a > b ? a : b)}d', color: AppTheme.accentRed, isDark: isDark),
            const SizedBox(width: 12),
            _HabitStat(title: 'Completed', value: '${habits.where((h) => h.weekProgress[DateTime.now().weekday - 1]).length}/${habits.length}', color: AppTheme.accentGreen, isDark: isDark),
          ]),
          const SizedBox(height: 24),

          // Day Header
          Row(children: [
            const SizedBox(width: 160),
            ...List.generate(7, (i) => Expanded(child: Center(child: Text(days[i],
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: i == DateTime.now().weekday - 1 ? AppTheme.primaryBlue : (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)))))),
          ]),
          const SizedBox(height: 12),

          // Habits
          ...habits.map((h) => _HabitRow(habit: h, isDark: isDark)),
        ]),
      ),
    );
  }
}

class _HabitRow extends ConsumerWidget {
  final HabitModel habit;
  final bool isDark;
  const _HabitRow({required this.habit, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(isDark: isDark),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(habit.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(habit.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
            Text('🔥 ${habit.currentStreak} day streak', style: GoogleFonts.inter(fontSize: 11, color: habit.color, fontWeight: FontWeight.w600)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: habit.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: Text('${(habit.completionRate * 100).toInt()}%', style: GoogleFonts.inter(color: habit.color, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: List.generate(7, (i) {
          final done = habit.weekProgress[i];
          return Expanded(child: GestureDetector(
            onTap: () => ref.read(habitsProvider.notifier).toggle(habit.id, i),
            child: Center(child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28, height: 28,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: done ? habit.color : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: done ? habit.color : (isDark ? AppTheme.borderDark : AppTheme.borderLight), width: 1.5),
              ),
              child: done ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            )),
          ));
        })),
      ]),
    );
  }
}

class _HabitStat extends StatelessWidget {
  final String title, value;
  final Color color;
  final bool isDark;
  const _HabitStat({required this.title, required this.value, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(isDark: isDark),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
        Text(title, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
      ]),
    ));
  }
}
