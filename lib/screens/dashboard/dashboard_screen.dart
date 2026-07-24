import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_insight_ai/providers/providers.dart';
import 'package:student_insight_ai/core/data/sample_data.dart';
import 'package:student_insight_ai/core/models/models.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider);
    final isDark = ref.watch(themeProvider);
    final assignments = ref.watch(assignmentsProvider);
    final pending = assignments.where((a) => !a.isDone).toList();
    final todaySchedule = ref.watch(timetableProvider.notifier).forToday();
    final quote = SampleData.motivationalQuotes[DateTime.now().day % SampleData.motivationalQuotes.length];
    final bg = isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(student, context, ref, isDark),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatGrid(student, isDark, context, ref),
                const SizedBox(height: 24),
                _SectionHeader(
                  title: "Today's Schedule",
                  subtitle: todaySchedule.isEmpty ? 'No classes today' : '${todaySchedule.length} classes',
                  isDark: isDark,
                  trailing: todaySchedule.isEmpty ? null : 'View All',
                  onTrailingTap: () => ref.read(navIndexProvider.notifier).state = 3,
                ),
                const SizedBox(height: 12),
                _buildScheduleFromTimetable(todaySchedule, isDark, ref),
                const SizedBox(height: 24),
                _SectionHeader(title: 'Quick Actions', isDark: isDark),
                const SizedBox(height: 12),
                _buildQuickActions(context, isDark),
                const SizedBox(height: 24),
                _SectionHeader(title: 'Weekly Study Chart', subtitle: 'This week', isDark: isDark),
                const SizedBox(height: 12),
                _WeeklyChart(isDark: isDark),
                const SizedBox(height: 24),
                _SectionHeader(title: 'Upcoming Exams', isDark: isDark),
                const SizedBox(height: 12),
                _buildExams(isDark),
                const SizedBox(height: 24),
                _SectionHeader(title: 'Pending Assignments', subtitle: '${pending.length} due', isDark: isDark),
                const SizedBox(height: 12),
                ...pending.take(3).map((a) => _AssignmentTile(a: a, isDark: isDark)),
                const SizedBox(height: 24),
                _buildQuote(quote, isDark),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(StudentModel student, BuildContext context, WidgetRef ref, bool isDark) {
    final photoPath = ref.watch(profilePhotoProvider);
    return SliverAppBar(
      expandedHeight: 175,
      pinned: true,
      backgroundColor: AppTheme.primaryBlue,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.primaryBlue, Color(0xFF4285F4)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Welcome back 👋', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(student.name, style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                          child: Text('${student.department} • ${student.semester}', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/notifications'),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white,
                          backgroundImage: photoPath != null ? FileImage(File(photoPath)) : null,
                          child: photoPath == null ? Text(student.avatarInitials ?? 'S', style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontSize: 20, fontWeight: FontWeight.bold)) : null,
                        ),
                        Positioned(
                          right: 0, top: 0,
                          child: Container(
                            width: 12, height: 12,
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatGrid(StudentModel student, bool isDark, BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(child: Column(children: [
          _StatCard(
            title: 'Current GPA',
            value: student.cgpa.toStringAsFixed(1),
            sub: 'Predicted: ${student.predictedCgpa.toStringAsFixed(1)}',
            icon: Icons.star_rounded,
            color: AppTheme.accentAmber,
            isDark: isDark,
            onTap: () => _showCGPACalculator(context, ref),
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Placement',
            value: '${student.placementScore.toInt()}%',
            sub: 'Industry Ready',
            icon: Icons.work_rounded,
            color: AppTheme.accentPurple,
            isDark: isDark,
            onTap: () => context.push('/placement'),
          ),
        ])),
        const SizedBox(width: 12),
        Expanded(child: Column(children: [
          _StatCard(
            title: 'Attendance',
            value: '${student.attendancePercent.toInt()}%',
            sub: 'Safe zone ✅',
            icon: Icons.check_circle_rounded,
            color: AppTheme.accentGreen,
            isDark: isDark,
            onTap: () => ref.read(navIndexProvider.notifier).state = 1, // Go to Analytics (Marks/Attendance)
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Streak',
            value: '${student.codingStreak}d',
            sub: 'Coding streak 🔥',
            icon: Icons.local_fire_department_rounded,
            color: AppTheme.accentRed,
            isDark: isDark,
            onTap: () => _showStreakEditor(context, ref, student.codingStreak),
          ),
        ])),
      ],
    );
  }

  void _showCGPACalculator(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _CGPACalculatorDialog(isDark: ref.watch(themeProvider)),
    );
  }

  void _showStreakEditor(BuildContext context, WidgetRef ref, int current) {
    final ctrl = TextEditingController(text: current.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Coding Streak'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Days'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () {
            final val = int.tryParse(ctrl.text) ?? 0;
            ref.read(studentProvider.notifier).updateField(codingStreak: val);
            Navigator.pop(context);
          }, child: const Text('Save')),
        ],
      ),
    );
  }

  Widget _buildScheduleFromTimetable(List<TimetableEntry> entries, bool isDark, WidgetRef ref) {
    if (entries.isEmpty) {
      return Container(
        height: 110,
        decoration: AppTheme.cardDecoration(isDark: isDark),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.event_busy_rounded, size: 32,
                color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
            const SizedBox(height: 8),
            Text('No classes today — Enjoy your day! 🎉',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
          ]),
        ),
      );
    }
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final s = entries[i];
          return Container(
            width: 150,
            padding: const EdgeInsets.all(14),
            decoration: AppTheme.cardDecoration(isDark: isDark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: s.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(s.icon, color: s.color, size: 18),
                ),
                const Spacer(),
                Text(s.subject,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text('${s.startTime} - ${s.endTime}',
                    style: GoogleFonts.inter(
                        color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                        fontSize: 10)),
                Text(s.room,
                    style: GoogleFonts.inter(
                        color: s.color, fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildQuickActions(BuildContext context, bool isDark) {
    final actions = [
      {'icon': Icons.timer_rounded, 'label': 'Pomodoro', 'color': AppTheme.primaryBlue, 'route': '/pomodoro'},
      {'icon': Icons.track_changes_rounded, 'label': 'Habits', 'color': AppTheme.accentGreen, 'route': '/habit-tracker'},
      {'icon': Icons.work_outline_rounded, 'label': 'Placement', 'color': AppTheme.accentPurple, 'route': '/placement'},
      {'icon': Icons.bar_chart_rounded, 'label': 'Analytics', 'color': AppTheme.accentOrange, 'route': null},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((a) => GestureDetector(
        onTap: () { if (a['route'] != null) context.push(a['route'] as String); },
        child: Column(children: [
          Container(
            height: 58, width: 58,
            decoration: BoxDecoration(color: (a['color'] as Color).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)),
            child: Icon(a['icon'] as IconData, color: a['color'] as Color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(a['label'] as String, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
        ]),
      )).toList(),
    );
  }

  Widget _buildExams(bool isDark) {
    return Column(
      children: SampleData.upcomingExams.take(3).map((e) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: AppTheme.cardDecoration(isDark: isDark),
        child: Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: AppTheme.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${e.daysLeft}', style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 16, height: 1.0)),
              Text('days', style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontSize: 9, fontWeight: FontWeight.w600)),
            ]),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.subject, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(e.date, style: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight, fontSize: 11)),
            Text('Syllabus: ${e.syllabus}', style: GoogleFonts.inter(color: AppTheme.accentAmber, fontSize: 10, fontWeight: FontWeight.w600)),
          ])),
        ]),
      )).toList(),
    );
  }

  Widget _buildQuote(String quote, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: AppTheme.gradientDecoration(),
      child: Column(children: [
        const Icon(Icons.format_quote_rounded, color: Colors.white54, size: 36),
        const SizedBox(height: 8),
        Text(quote, textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.white, fontSize: 13, height: 1.6, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

// ─── Reusable Widgets ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailing;
  final VoidCallback? onTrailingTap;
  final bool isDark;
  
  const _SectionHeader({
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTrailingTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
          if (subtitle != null) Text(subtitle!, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
        ]),
        if (trailing != null || onTrailingTap != null)
          TextButton(
            onPressed: onTrailingTap ?? () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Text(trailing ?? 'See All', style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value, sub;
  final IconData icon;
  final Color color;
  final bool isDark;
  final VoidCallback? onTap;
  const _StatCard({required this.title, required this.value, required this.sub, required this.icon, required this.color, this.isDark = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration(isDark: isDark),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 18)),
          const SizedBox(height: 14),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (_, val, __) {
              String display = value.contains('%') ? '${val.toInt()}%' : value.contains('d') ? '${val.toInt()}d' : val.toStringAsFixed(1);
              return Text(display, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight));
            },
          ),
          const SizedBox(height: 2),
          Text(title, style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight, fontWeight: FontWeight.w500)),
          Text(sub, style: GoogleFonts.inter(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

class _AssignmentTile extends StatelessWidget {
  final AssignmentModel a;
  final bool isDark;
  const _AssignmentTile({required this.a, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final color = a.daysLeft <= 1 ? AppTheme.accentRed : a.daysLeft <= 3 ? AppTheme.accentAmber : AppTheme.accentGreen;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(isDark: isDark),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.assignment_rounded, color: color, size: 22)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(a.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(a.subject, style: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight, fontSize: 11)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
          child: Text(a.daysLeft == 0 ? 'Today' : '${a.daysLeft}d', style: GoogleFonts.inter(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final bool isDark;
  const _WeeklyChart({this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final data = SampleData.weeklyData;
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(12, 20, 16, 12),
      decoration: AppTheme.cardDecoration(isDark: isDark),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 10,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
              final i = v.toInt();
              if (i < data.length) return Padding(padding: const EdgeInsets.only(top: 6), child: Text(data[i].day, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)));
              return const SizedBox();
            })),
          ),
          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: isDark ? AppTheme.borderDark : AppTheme.borderLight, strokeWidth: 1)),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(data.length, (i) => BarChartGroupData(x: i, barRods: [
            BarChartRodData(
              toY: data[i].studyHours, color: AppTheme.primaryBlue, width: 14,
              borderRadius: BorderRadius.circular(4),
              backDrawRodData: BackgroundBarChartRodData(show: true, toY: 10, color: isDark ? AppTheme.surfaceDark : AppTheme.backgroundLight),
            ),
          ])),
        ),
      ),
    );
  }
}

// ─── CGPA Calculator Dialog ──────────────────────────────────────────────────
class _CGPACalculatorDialog extends ConsumerStatefulWidget {
  final bool isDark;
  const _CGPACalculatorDialog({required this.isDark});
  @override
  ConsumerState<_CGPACalculatorDialog> createState() => _CGPACalculatorDialogState();
}

class _CGPACalculatorDialogState extends ConsumerState<_CGPACalculatorDialog> {
  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectsProvider);
    double totalCredits = 0;
    double weightedPoints = 0;

    for (final s in subjects) {
      totalCredits += s.credits;
      weightedPoints += (s.gradePoint * s.credits);
    }

    final cgpa = totalCredits > 0 ? weightedPoints / totalCredits : 0.0;

    return AlertDialog(
      title: const Text('CGPA Calculator'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Calculated based on your marks:', style: GoogleFonts.inter(fontSize: 12)),
            const SizedBox(height: 16),
            ...subjects.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(child: Text(s.name, style: GoogleFonts.inter(fontSize: 13))),
                  Text('${s.grade} (${s.credits} cr)', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            )),
            const Divider(),
            const SizedBox(height: 8),
            Text('Final CGPA', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            Text(cgpa.toStringAsFixed(2), style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ElevatedButton(
          onPressed: () {
            ref.read(studentProvider.notifier).updateField(cgpa: cgpa);
            Navigator.pop(context);
          },
          child: const Text('Save to Profile'),
        ),
      ],
    );
  }
}
