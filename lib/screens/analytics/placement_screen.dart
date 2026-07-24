import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/core/data/sample_data.dart';
import 'package:student_insight_ai/providers/providers.dart';

class PlacementScreen extends ConsumerWidget {
  const PlacementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final student = ref.watch(studentProvider);
    final skills = SampleData.skills;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context), color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
        backgroundColor: Colors.transparent,
        title: Text('Placement Module', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Readiness Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.gradientDecoration(),
            child: Row(children: [
              CircularPercentIndicator(
                radius: 50,
                lineWidth: 10,
                percent: student.placementScore / 100,
                center: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${student.placementScore.toInt()}%', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, height: 1.0)),
                  Text('Ready', style: GoogleFonts.inter(color: Colors.white70, fontSize: 9)),
                ]),
                progressColor: Colors.white,
                backgroundColor: Colors.white30,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(width: 20),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Placement Readiness', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
                Text('Good Progress! 🎯', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                Text('Target: TCS, Infosys, Wipro', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
              ])),
            ]),
          ),
          const SizedBox(height: 24),

          // AI Suggestions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentAmber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accentAmber.withValues(alpha: 0.4)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.lightbulb_rounded, color: AppTheme.accentAmber, size: 20),
                const SizedBox(width: 8),
                Text('AI Suggestions', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.accentAmber, fontSize: 14)),
              ]),
              const SizedBox(height: 10),
              ...[
                '📌 Solve 3 DSA problems daily on LeetCode',
                '📖 Learn System Design basics (YouTube)',
                '🗣️ Practice HR questions for 30 min daily',
                '📄 Update your resume with recent projects',
              ].map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(tip, style: GoogleFonts.inter(fontSize: 13, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
              )),
            ]),
          ),
          const SizedBox(height: 24),

          // Skills
          Text('Technical Skills', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration(isDark: isDark),
            child: Column(children: skills.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: s.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(s.name[0], style: GoogleFonts.inter(color: s.color, fontWeight: FontWeight.bold, fontSize: 14))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(s.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight))),
                    Text('${(s.proficiency * 100).toInt()}%', style: GoogleFonts.inter(color: s.color, fontWeight: FontWeight.bold, fontSize: 12)),
                  ]),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(value: s.proficiency, color: s.color, backgroundColor: isDark ? AppTheme.borderDark : AppTheme.borderLight, minHeight: 6, borderRadius: BorderRadius.circular(4)),
                ])),
              ]),
            )).toList()),
          ),
          const SizedBox(height: 24),

          // Company Tracker
          Text('Target Companies', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
          const SizedBox(height: 12),
          ...[
            {'name': 'TCS', 'status': 'Research Phase', 'color': AppTheme.primaryBlue, 'ready': true},
            {'name': 'Infosys', 'status': 'Research Phase', 'color': AppTheme.accentGreen, 'ready': true},
            {'name': 'Wipro', 'status': 'Preparing', 'color': AppTheme.accentAmber, 'ready': false},
            {'name': 'Cognizant', 'status': 'Preparing', 'color': AppTheme.accentPurple, 'ready': false},
          ].map((c) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: AppTheme.cardDecoration(isDark: isDark),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: (c['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text((c['name'] as String)[0], style: GoogleFonts.inter(color: c['color'] as Color, fontWeight: FontWeight.bold, fontSize: 16))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c['name'] as String, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
                Text(c['status'] as String, style: GoogleFonts.inter(fontSize: 12, color: c['color'] as Color)),
              ])),
              Icon(c['ready'] as bool ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: c['ready'] as bool ? AppTheme.accentGreen : (isDark ? AppTheme.borderDark : AppTheme.borderLight)),
            ]),
          )),
          const SizedBox(height: 24),

          // Mock Interview CTA
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.accentGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentGreen.withValues(alpha: 0.3)),
            ),
            child: Row(children: [
              const Icon(Icons.mic_rounded, color: AppTheme.accentGreen, size: 32),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Mock Interview', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
                Text('Practice with AI-generated HR & technical questions', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
              ])),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.accentGreen),
            ]),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
