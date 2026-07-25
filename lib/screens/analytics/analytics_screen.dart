import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:student_insight_ai/core/data/sample_data.dart';
import 'package:student_insight_ai/core/models/models.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/providers/providers.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final student = ref.watch(studentProvider);
    final bg = isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Analytics', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppTheme.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: Text('Sem 6', style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 13),
          tabs: const [Tab(text: 'Marks'), Tab(text: 'Attendance')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _MarksTab(isDark: isDark),
          _AttendanceTab(isDark: isDark),
        ],
      ),
    );
  }
}

// ─── Marks Tab ────────────────────────────────────────────────────────────────
class _MarksTab extends ConsumerWidget {
  final bool isDark;
  const _MarksTab({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectsProvider);
    final weakSubjects = subjects.where((s) => s.isWeak).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Summary Cards
        Row(children: [
          _MiniCard(title: 'Avg Score', value: '${(subjects.fold(0.0, (s, e) => s + e.percentage) / subjects.length).toStringAsFixed(1)}%', color: AppTheme.primaryBlue, isDark: isDark),
          const SizedBox(width: 12),
          _MiniCard(title: 'Best Subject', value: subjects.reduce((a, b) => a.percentage > b.percentage ? a : b).code, color: AppTheme.accentGreen, isDark: isDark),
          const SizedBox(width: 12),
          _MiniCard(title: 'Weak Subjects', value: '${weakSubjects.length}', color: AppTheme.accentRed, isDark: isDark),
        ]),
        const SizedBox(height: 24),

        // Bar Chart
        Text('Subject-wise Marks', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
        const SizedBox(height: 12),
        Container(
          height: 220,
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.cardDecoration(isDark: isDark),
          child: BarChart(BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            barTouchData: BarTouchData(enabled: true, touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, _, rod, __) => BarTooltipItem('${rod.toY.toInt()}%', GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < subjects.length) return Padding(padding: const EdgeInsets.only(top: 6), child: Text(subjects[i].code.replaceAll('CS', ''), style: GoogleFonts.inter(fontSize: 9, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)));
                return const SizedBox();
              })),
            ),
            gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: isDark ? AppTheme.borderDark : AppTheme.borderLight, strokeWidth: 1)),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(subjects.length, (i) => BarChartGroupData(x: i, barRods: [
              BarChartRodData(toY: subjects[i].percentage, color: subjects[i].color, width: 16, borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(show: true, toY: 100, color: isDark ? AppTheme.surfaceDark : AppTheme.backgroundLight)),
            ])),
          )),
        ),
        const SizedBox(height: 24),

        // Subject Cards
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subject Performance', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
            Text('Tap to edit', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.primaryBlue)),
          ],
        ),
        const SizedBox(height: 12),
        ...subjects.map((s) => _SubjectCard(subject: s, isDark: isDark, onTap: () => _showEditMarksDialog(context, ref, s))),

        if (weakSubjects.isNotEmpty) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppTheme.accentRed.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.accentRed.withValues(alpha: 0.3))),
            child: Row(children: [
              const Icon(Icons.warning_rounded, color: AppTheme.accentRed),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('⚠️ Weak Subjects Detected', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.accentRed, fontSize: 13)),
                Text(weakSubjects.map((s) => s.name).join(', '), style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
              ])),
            ]),
          ),
        ],
      ]),
    );
  }

  void _showEditMarksDialog(BuildContext context, WidgetRef ref, SubjectModel s) {
    final marksCtrl = TextEditingController(text: s.marks.toInt().toString());
    final creditsCtrl = TextEditingController(text: s.credits.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update ${s.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: marksCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Marks (out of 100)')),
            TextField(controller: creditsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Credits')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () {
            final marks = double.tryParse(marksCtrl.text) ?? s.marks;
            final credits = int.tryParse(creditsCtrl.text) ?? s.credits;
            ref.read(subjectsProvider.notifier).updateMarks(s.id, marks);
            ref.read(subjectsProvider.notifier).updateCredits(s.id, credits);
            Navigator.pop(context);
          }, child: const Text('Save')),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final bool isDark;
  final VoidCallback? onTap;
  const _SubjectCard({required this.subject, required this.isDark, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: AppTheme.cardDecoration(isDark: isDark),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: subject.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(subject.icon, color: subject.color, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(subject.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight), overflow: TextOverflow.ellipsis)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: subject.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                child: Text(subject.grade, style: GoogleFonts.inter(color: subject.color, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(child: LinearProgressIndicator(
                value: subject.percentage / 100,
                backgroundColor: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                color: subject.color,
                minHeight: 6,
                borderRadius: BorderRadius.circular(4),
              )),
              const SizedBox(width: 8),
              Text('${subject.percentage.toInt()}%', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: subject.color)),
            ]),
          ])),
        ]),
      ),
    );
  }
}

class _AttendanceTab extends ConsumerWidget {
  final bool isDark;
  const _AttendanceTab({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectsProvider);
    final avg = subjects.fold(0.0, (s, e) => s + e.attendancePercent) / subjects.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        // Overall ring
        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.cardDecoration(isDark: isDark),
          child: Column(children: [
            Text('Overall Attendance', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
            const SizedBox(height: 16),
            CircularPercentIndicator(
              radius: 80,
              lineWidth: 14,
              percent: avg / 100,
              center: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${avg.toInt()}%', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
                Text('Average', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
              ]),
              progressColor: avg >= 80 ? AppTheme.accentGreen : AppTheme.accentRed,
              backgroundColor: isDark ? AppTheme.borderDark : AppTheme.borderLight,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
            ),
            const SizedBox(height: 12),
            Text(avg >= 80 ? '✅ You\'re safe! Keep it up.' : '⚠️ Below 80% — Attend more classes!',
                style: GoogleFonts.inter(color: avg >= 80 ? AppTheme.accentGreen : AppTheme.accentRed, fontWeight: FontWeight.w600)),
          ]),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subject Attendance', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
            Text('Tap to edit', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.primaryBlue)),
          ],
        ),
        const SizedBox(height: 12),
        ...subjects.map((s) => GestureDetector(
          onTap: () => _showEditAttendanceDialog(context, ref, s),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: AppTheme.cardDecoration(isDark: isDark),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(s.icon, color: s.color, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(s.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight))),
                Text('${s.attendancePercent.toInt()}%', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: s.attendancePercent >= 80 ? AppTheme.accentGreen : AppTheme.accentRed, fontSize: 13)),
              ]),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: s.attendancePercent / 100,
                color: s.attendancePercent >= 80 ? AppTheme.accentGreen : AppTheme.accentRed,
                backgroundColor: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                minHeight: 7,
                borderRadius: BorderRadius.circular(4),
              ),
            ]),
          ),
        )),
      ]),
    );
  }

  void _showEditAttendanceDialog(BuildContext context, WidgetRef ref, SubjectModel s) {
    final ctrl = TextEditingController(text: s.attendancePercent.toInt().toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Attendance: ${s.name}'),
        content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Percentage (%)')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () {
            final val = double.tryParse(ctrl.text) ?? s.attendancePercent;
            ref.read(subjectsProvider.notifier).updateAttendance(s.id, val);
            // Also update overall student attendance if necessary? 
            // Better to compute it reactively in the dashboard.
            Navigator.pop(context);
          }, child: const Text('Save')),
        ],
      ),
    );
  }
}


class _MiniCard extends StatelessWidget {
  final String title, value;
  final Color color;
  final bool isDark;
  const _MiniCard({required this.title, required this.value, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(12),
      decoration: AppTheme.cardDecoration(isDark: isDark),
      child: Column(children: [
        Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
        const SizedBox(height: 2),
        Text(title, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight), textAlign: TextAlign.center),
      ]),
    ));
  }
}
