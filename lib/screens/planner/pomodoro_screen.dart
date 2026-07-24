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

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  void _startStop() {
    final notifier = ref.read(pomodoroProvider.notifier);
    notifier.toggle();
    final state = ref.read(pomodoroProvider);
    if (!state.isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => notifier.tick());
    } else {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final state = ref.watch(pomodoroProvider);
    final progress = state.isBreak
        ? 1 - (state.minutes * 60 + state.seconds) / 300
        : 1 - (state.minutes * 60 + state.seconds) / 1500;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context),
            color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
        backgroundColor: Colors.transparent,
        title: Text('Pomodoro Timer', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          // Mode Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: state.isBreak ? AppTheme.accentGreen.withValues(alpha: 0.1) : AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(state.isBreak ? '☕ Break Time' : '🎯 Focus Session', style: GoogleFonts.inter(color: state.isBreak ? AppTheme.accentGreen : AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 40),

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
              Text(state.isBreak ? 'Break' : 'Focus', style: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
            ]),
          ]),
          const SizedBox(height: 40),

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
          Text('${state.completedSessions} sessions completed', style: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight, fontSize: 12)),
          const SizedBox(height: 40),

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
          const SizedBox(height: 32),

          // Presets
          Text('Duration Presets', style: GoogleFonts.inter(fontSize: 13, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: _presets.map((m) => GestureDetector(
            onTap: () { _timer?.cancel(); ref.read(pomodoroProvider.notifier).setDuration(m); },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: state.minutes == m ? AppTheme.primaryBlue : (isDark ? AppTheme.cardDark : Colors.white),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: state.minutes == m ? AppTheme.primaryBlue : (isDark ? AppTheme.borderDark : AppTheme.borderLight)),
              ),
              child: Text('$m min', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: state.minutes == m ? Colors.white : (isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight))),
            ),
          )).toList()),
        ]),
      ),
    );
  }
}
