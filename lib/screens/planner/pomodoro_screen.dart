import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/providers/providers.dart';

class PomodoroScreen extends ConsumerStatefulWidget {
  const PomodoroScreen({super.key});
  @override
  ConsumerState<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends ConsumerState<PomodoroScreen> {
  Timer? _timer;
  final List<int> _presets = [25, 45, 60];
  final TextEditingController _subjectCtrl = TextEditingController();
  final TextEditingController _customMinsCtrl = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    _subjectCtrl.dispose();
    _customMinsCtrl.dispose();
    super.dispose();
  }

  void _startStop() {
    final notifier = ref.read(pomodoroProvider.notifier);
    final state = ref.read(pomodoroProvider);

    // If timer hasn't started yet, apply subject + custom duration
    if (!state.isRunning && state.minutes == state.totalInitialMinutes && state.seconds == 0) {
      final customMins = int.tryParse(_customMinsCtrl.text);
      if (customMins != null && customMins > 0) {
        notifier.setDuration(customMins, subject: _subjectCtrl.text.trim());
      } else {
        notifier.setDuration(state.totalInitialMinutes, subject: _subjectCtrl.text.trim());
      }
    }

    notifier.toggle();
    final newState = ref.read(pomodoroProvider);
    if (newState.isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => notifier.tick());
    } else {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final state = ref.watch(pomodoroProvider);

    final totalSecs = state.isBreak ? 300 : (state.totalInitialMinutes * 60);
    final remainingSecs = state.minutes * 60 + state.seconds;
    final progress = totalSecs > 0 ? 1.0 - (remainingSecs / totalSecs) : 0.0;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
          color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
        ),
        backgroundColor: Colors.transparent,
        title: Text('Pomodoro Timer',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          // Subject Input
          if (!state.isRunning) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration(isDark: isDark),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('📚 What are you studying?',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
                const SizedBox(height: 10),
                TextField(
                  controller: _subjectCtrl,
                  style: GoogleFonts.inter(color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
                  decoration: InputDecoration(
                    hintText: 'e.g. Data Structures, Machine Learning...',
                    hintStyle: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                    prefixIcon: Icon(Icons.menu_book_rounded, color: AppTheme.primaryBlue, size: 20),
                    filled: true,
                    fillColor: isDark ? AppTheme.backgroundDark : Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                Text('⏱ Custom Duration (minutes)',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
                const SizedBox(height: 10),
                TextField(
                  controller: _customMinsCtrl,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
                  decoration: InputDecoration(
                    hintText: 'e.g. 30, 45, 90 (leave blank for preset)',
                    hintStyle: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                    prefixIcon: Icon(Icons.timer_rounded, color: AppTheme.primaryBlue, size: 20),
                    filled: true,
                    fillColor: isDark ? AppTheme.backgroundDark : Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
          ],

          // Currently Studying Label
          if (state.isRunning && state.subject.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.menu_book_rounded, color: AppTheme.primaryBlue, size: 16),
                const SizedBox(width: 6),
                Text('Studying: ${state.subject}',
                    style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 13)),
              ]),
            ),

          // Mode Chip
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: state.isBreak ? AppTheme.accentGreen.withValues(alpha: 0.1) : AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(state.isBreak ? '☕ Break Time' : '🎯 Focus Session',
                style: GoogleFonts.inter(color: state.isBreak ? AppTheme.accentGreen : AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),

          // Timer Circle
          Stack(alignment: Alignment.center, children: [
            SizedBox(
              width: 240, height: 240,
              child: CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 12,
                backgroundColor: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                color: state.isBreak ? AppTheme.accentGreen : AppTheme.primaryBlue,
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${state.minutes.toString().padLeft(2, '0')}:${state.seconds.toString().padLeft(2, '0')}',
                  style: GoogleFonts.inter(fontSize: 56, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
              Text(state.isBreak ? 'Break' : 'Focus',
                  style: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
            ]),
          ]),
          const SizedBox(height: 24),

          // Sessions
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(4, (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 14, height: 14,
            decoration: BoxDecoration(
              color: i < state.completedSessions ? AppTheme.primaryBlue : (isDark ? AppTheme.borderDark : AppTheme.borderLight),
              borderRadius: BorderRadius.circular(3),
            ),
          ))),
          const SizedBox(height: 8),
          Text('${state.completedSessions} sessions completed',
              style: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight, fontSize: 12)),
          const SizedBox(height: 32),

          // Controls
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // Reset
            GestureDetector(
              onTap: () { _timer?.cancel(); ref.read(pomodoroProvider.notifier).reset(); },
              child: Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: isDark ? AppTheme.cardDark : Colors.white, borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppTheme.borderDark : AppTheme.borderLight)),
                child: Icon(Icons.refresh_rounded, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
              ),
            ),
            const SizedBox(width: 20),
            // Play/Pause
            GestureDetector(
              onTap: _startStop,
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue]),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: Icon(state.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 36),
              ),
            ),
            const SizedBox(width: 20),
            // Skip
            GestureDetector(
              onTap: () { _timer?.cancel(); ref.read(pomodoroProvider.notifier).reset(); },
              child: Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: isDark ? AppTheme.cardDark : Colors.white, borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppTheme.borderDark : AppTheme.borderLight)),
                child: Icon(Icons.skip_next_rounded, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
              ),
            ),
          ]),
          const SizedBox(height: 28),

          // Presets
          Text('Duration Presets',
              style: GoogleFonts.inter(fontSize: 13, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: _presets.map((m) => GestureDetector(
            onTap: () {
              _timer?.cancel();
              _customMinsCtrl.clear();
              ref.read(pomodoroProvider.notifier).setDuration(m, subject: _subjectCtrl.text.trim());
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: state.totalInitialMinutes == m && _customMinsCtrl.text.isEmpty
                    ? AppTheme.primaryBlue
                    : (isDark ? AppTheme.cardDark : Colors.white),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: state.totalInitialMinutes == m && _customMinsCtrl.text.isEmpty
                    ? AppTheme.primaryBlue
                    : (isDark ? AppTheme.borderDark : AppTheme.borderLight)),
              ),
              child: Text('$m min',
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: state.totalInitialMinutes == m && _customMinsCtrl.text.isEmpty
                          ? Colors.white
                          : (isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight))),
            ),
          )).toList()),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
