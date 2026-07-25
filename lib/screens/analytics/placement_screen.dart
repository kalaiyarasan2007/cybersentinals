import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/core/models/models.dart';
import 'package:student_insight_ai/providers/providers.dart';

class PlacementScreen extends ConsumerWidget {
  const PlacementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final skills = ref.watch(skillsProvider);

    // Auto-calculate placement readiness from all skills
    final placementScore = skills.isNotEmpty
        ? skills.fold(0.0, (sum, s) => sum + s.proficiency) / skills.length * 100
        : 0.0;

    String readinessLabel;
    String targetCompanies;
    if (placementScore >= 80) {
      readinessLabel = 'Excellent! 🚀 Top Company Ready';
      targetCompanies = 'Target: Google, Microsoft, Amazon';
    } else if (placementScore >= 60) {
      readinessLabel = 'Good Progress! 🎯';
      targetCompanies = 'Target: TCS, Infosys, Wipro';
    } else if (placementScore >= 40) {
      readinessLabel = 'Keep Improving! 💪';
      targetCompanies = 'Target: Entry-level companies';
    } else {
      readinessLabel = 'Just Getting Started! 📚';
      targetCompanies = 'Focus on building skills first';
    }

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
          color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
        ),
        backgroundColor: Colors.transparent,
        title: Text('Placement Module',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppTheme.primaryBlue),
            onPressed: () => _showAddSkillDialog(context, ref),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Readiness Card (Auto-calculated from skills) ──────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.gradientDecoration(),
            child: Row(children: [
              CircularPercentIndicator(
                radius: 50,
                lineWidth: 10,
                percent: (placementScore / 100).clamp(0.0, 1.0),
                center: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${placementScore.toInt()}%',
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, height: 1.0)),
                  Text('Ready', style: GoogleFonts.inter(color: Colors.white70, fontSize: 9)),
                ]),
                progressColor: Colors.white,
                backgroundColor: Colors.white30,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
              ),
              const SizedBox(width: 20),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Placement Readiness', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
                Text(readinessLabel,
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text('Auto-calculated from your skills ✨',
                    style: GoogleFonts.inter(color: Colors.white60, fontSize: 10)),
                const SizedBox(height: 6),
                Text(targetCompanies, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
              ])),
            ]),
          ),
          const SizedBox(height: 24),

          // ── Technical Skills ──────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Technical Skills',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
              Text('Tap to edit', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.primaryBlue)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration(isDark: isDark),
            child: Column(children: skills.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GestureDetector(
                onTap: () => _showEditSkillDialog(context, ref, s),
                child: Row(children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: s.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text(s.name[0],
                        style: GoogleFonts.inter(color: s.color, fontWeight: FontWeight.bold, fontSize: 14))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(s.name,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13,
                              color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight))),
                      Text('${(s.proficiency * 100).toInt()}%',
                          style: GoogleFonts.inter(color: s.color, fontWeight: FontWeight.bold, fontSize: 12)),
                    ]),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                        value: s.proficiency,
                        color: s.color,
                        backgroundColor: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(4)),
                  ])),
                ]),
              ),
            )).toList()),
          ),
          const SizedBox(height: 24),

          // ── Mock Interview CTA ────────────────────────────────────────────
          GestureDetector(
            onTap: () => context.push('/mock-interview'),
            child: Container(
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
                  Text('Mock Interview',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15,
                          color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
                  Text('Practice with AI-generated HR & technical questions',
                      style: GoogleFonts.inter(fontSize: 12,
                          color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
                ])),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.accentGreen),
              ]),
            ),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  void _showAddSkillDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    double proficiency = 0.5;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Skill'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Skill Name (e.g. Flutter)')),
              const SizedBox(height: 16),
              Text('Proficiency: ${(proficiency * 100).toInt()}%'),
              Slider(
                value: proficiency,
                onChanged: (v) => setDialogState(() => proficiency = v),
                divisions: 10,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                ref.read(skillsProvider.notifier).add(SkillModel(
                  id: DateTime.now().toString(),
                  name: nameCtrl.text,
                  category: 'Programming',
                  proficiency: proficiency,
                  color: AppTheme.primaryBlue,
                ));
              }
              Navigator.pop(context);
            }, child: const Text('Add')),
          ],
        ),
      ),
    );
  }

  void _showEditSkillDialog(BuildContext context, WidgetRef ref, SkillModel s) {
    double val = s.proficiency;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit ${s.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Proficiency: ${(val * 100).toInt()}%'),
              Slider(
                value: val,
                onChanged: (v) => setDialogState(() => val = v),
                divisions: 10,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(skillsProvider.notifier).delete(s.id);
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(onPressed: () {
              ref.read(skillsProvider.notifier).updateProficiency(s.id, val);
              Navigator.pop(context);
            }, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
