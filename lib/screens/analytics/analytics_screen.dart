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
    _tab = TabController(length: 3, vsync: this);
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
          tabs: const [Tab(text: 'Marks'), Tab(text: 'Attendance'), Tab(text: 'Trends')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _MarksTab(isDark: isDark),
          _AttendanceTab(isDark: isDark),
          _TrendsTab(isDark: isDark, student: student),
        ],
      ),
    );
  }
}

// ─── Marks Tab ────────────────────────────────────────────────────────────────
class _MarksTab extends StatelessWidget {
  final bool isDark;
  const _MarksTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final subjects = SampleData.subjects;
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
        Text('Subject Performance', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
        const SizedBox(height: 12),
        ...subjects.map((s) => _SubjectCard(subject: s, isDark: isDark)),

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
}

class _SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final bool isDark;
  const _SubjectCard({required this.subject, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

// ─── Attendance Tab ───────────────────────────────────────────────────────────
class _AttendanceTab extends StatelessWidget {
  final bool isDark;
  const _AttendanceTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final subjects = SampleData.subjects;
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
        ...subjects.map((s) => Container(
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
        )),
      ]),
    );
  }
}

// ─── Trends Tab ───────────────────────────────────────────────────────────────
class _TrendsTab extends StatelessWidget {
  final bool isDark;
  final dynamic student;
  const _TrendsTab({required this.isDark, required this.student});

  @override
  Widget build(BuildContext context) {
    final data = SampleData.semesterTrend;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('CGPA Trend', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
        const SizedBox(height: 12),
        Container(
          height: 220,
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.cardDecoration(isDark: isDark),
          child: LineChart(LineChartData(
            minY: 6, maxY: 10,
            gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: isDark ? AppTheme.borderDark : AppTheme.borderLight, strokeWidth: 1)),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < data.length) return Text(data[i].semester, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight));
                return const SizedBox();
              })),
            ),
            lineBarsData: [LineChartBarData(
              spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i].cgpa)),
              isCurved: true,
              color: AppTheme.primaryBlue,
              barWidth: 3,
              dotData: FlDotData(show: true, getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(radius: 5, color: AppTheme.primaryBlue, strokeColor: Colors.white, strokeWidth: 2)),
              belowBarData: BarAreaData(show: true, color: AppTheme.primaryBlue.withValues(alpha: 0.1)),
            )],
          )),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.gradientDecoration(),
          child: Row(children: [
            const Icon(Icons.trending_up_rounded, color: Colors.white, size: 28),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Predicted Next Sem', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
              Text('CGPA: ${student.predictedCgpa.toStringAsFixed(1)} 🎯', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ]),
          ]),
        ),
      ]),
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
