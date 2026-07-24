import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/core/models/models.dart';
import 'package:student_insight_ai/core/data/sample_data.dart';
import 'package:student_insight_ai/providers/providers.dart';

class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({super.key});
  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text('Planner', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
        actions: [
          IconButton(icon: const Icon(Icons.timer_rounded, color: AppTheme.primaryBlue), onPressed: () => context.push('/pomodoro')),
          IconButton(icon: const Icon(Icons.track_changes_rounded, color: AppTheme.accentGreen), onPressed: () => context.push('/habit-tracker')),
        ],
        bottom: TabBar(
          controller: _tab,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 13),
          tabs: const [Tab(text: 'Tasks'), Tab(text: 'Exams')],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context, isDark),
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Task', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _TasksTab(isDark: isDark),
          _ExamsTab(isDark: isDark),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, bool isDark) {
    final titleCtrl = TextEditingController();
    String category = 'Study';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Add New Task', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
            const SizedBox(height: 16),
            TextField(
              controller: titleCtrl,
              autofocus: true,
              style: GoogleFonts.inter(color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
              decoration: InputDecoration(hintText: 'Task title...', hintStyle: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
            ),
            const SizedBox(height: 12),
            Wrap(spacing: 8, children: ['Study', 'Assignment', 'Coding', 'Placement'].map((c) => ChoiceChip(
              label: Text(c, style: GoogleFonts.inter(fontSize: 12, color: category == c ? Colors.white : (isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight))),
              selected: category == c,
              selectedColor: AppTheme.primaryBlue,
              onSelected: (_) => setS(() => category = c),
            )).toList()),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (titleCtrl.text.isNotEmpty) {
                    ref.read(tasksProvider.notifier).add(TaskModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleCtrl.text, category: category,
                      date: DateTime.now(), time: const TimeOfDay(hour: 9, minute: 0),
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Task'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _TasksTab extends ConsumerStatefulWidget {
  final bool isDark;
  const _TasksTab({required this.isDark});
  @override
  ConsumerState<_TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends ConsumerState<_TasksTab> {
  int _viewMode = 0; // 0: Today, 1: Weekly, 2: Monthly

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    final isDark = widget.isDark;

    List<TaskModel> filteredTasks = [];
    final now = DateTime.now();

    if (_viewMode == 0) {
      filteredTasks = tasks.where((t) => t.date.year == now.year && t.date.month == now.month && t.date.day == now.day).toList();
    } else if (_viewMode == 1) {
      // Current week (next 7 days approx)
      final nextWeek = now.add(const Duration(days: 7));
      filteredTasks = tasks.where((t) => t.date.isAfter(now.subtract(const Duration(days: 1))) && t.date.isBefore(nextWeek)).toList();
    } else {
      // Current month
      filteredTasks = tasks.where((t) => t.date.year == now.year && t.date.month == now.month).toList();
    }

    final done = filteredTasks.where((t) => t.isDone).length;
    final total = filteredTasks.length;
    final progress = total == 0 ? 0.0 : done / total;
    
    final viewLabels = ['Today', 'This Week', 'This Month'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // View Toggle
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceDark : AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? AppTheme.borderDark : AppTheme.borderLight),
          ),
          child: Row(
            children: List.generate(3, (index) => Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _viewMode = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _viewMode == index ? AppTheme.primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ['Today', 'Weekly', 'Monthly'][index],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: _viewMode == index ? FontWeight.bold : FontWeight.normal,
                      color: _viewMode == index ? Colors.white : (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                    ),
                  ),
                ),
              ),
            )),
          ),
        ),
        const SizedBox(height: 20),
        
        // Progress
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.gradientDecoration(),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${viewLabels[_viewMode]} Progress', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 4),
              Text('$done / $total completed', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white30,
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ])),
            const SizedBox(width: 16),
            Text('${(progress * 100).toInt()}%',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          ]),
        ),
        const SizedBox(height: 20),
        
        Text(viewLabels[_viewMode], style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
        const SizedBox(height: 10),
        
        if (filteredTasks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.task_alt_rounded, size: 48, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                  const SizedBox(height: 16),
                  Text('No tasks for ${viewLabels[_viewMode].toLowerCase()}', style: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
                ],
              ),
            ),
          )
        else
          ...filteredTasks.map((t) => _TaskTile(task: t, isDark: isDark)),
        
        const SizedBox(height: 80),
      ]),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  final TaskModel task;
  final bool isDark;
  const _TaskTile({required this.task, required this.isDark});

  Color get categoryColor {
    switch (task.category) {
      case 'Study': return AppTheme.primaryBlue;
      case 'Assignment': return AppTheme.accentRed;
      case 'Coding': return AppTheme.accentPurple;
      case 'Placement': return AppTheme.accentGreen;
      default: return AppTheme.accentAmber;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: AppTheme.accentRed, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) => ref.read(tasksProvider.notifier).delete(task.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: AppTheme.cardDecoration(isDark: isDark),
        child: ListTile(
          leading: GestureDetector(
            onTap: () => ref.read(tasksProvider.notifier).toggleDone(task.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: task.isDone ? AppTheme.accentGreen : Colors.transparent,
                border: Border.all(color: task.isDone ? AppTheme.accentGreen : categoryColor, width: 2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: task.isDone ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
            ),
          ),
          title: Text(task.title, style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: task.isDone ? (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight) : (isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          )),
          subtitle: Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: categoryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Text(task.category, style: GoogleFonts.inter(fontSize: 10, color: categoryColor, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 8),
            Text(task.time.format(context), style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
          ]),
          trailing: Icon(Icons.drag_handle_rounded, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
        ),
      ),
    );
  }
}

class _ExamsTab extends StatelessWidget {
  final bool isDark;
  const _ExamsTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final exams = SampleData.upcomingExams;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        ...exams.map((e) => Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: AppTheme.cardDecoration(isDark: isDark),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: e.daysLeft <= 5 ? AppTheme.accentRed.withValues(alpha: 0.1) : AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(children: [
                  Text('${e.daysLeft}', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: e.daysLeft <= 5 ? AppTheme.accentRed : AppTheme.primaryBlue, height: 1.0)),
                  Text('days', style: GoogleFonts.inter(fontSize: 9, color: e.daysLeft <= 5 ? AppTheme.accentRed : AppTheme.primaryBlue, fontWeight: FontWeight.w600)),
                ]),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.subject, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('📅 ${e.date}', style: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight, fontSize: 12)),
              ])),
              Icon(e.daysLeft <= 5 ? Icons.warning_amber_rounded : Icons.event_rounded, color: e.daysLeft <= 5 ? AppTheme.accentRed : AppTheme.accentAmber),
            ]),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: isDark ? AppTheme.surfaceDark : AppTheme.backgroundLight, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.book_rounded, color: AppTheme.accentAmber, size: 16),
                const SizedBox(width: 8),
                Text('Syllabus: ${e.syllabus}', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
              ]),
            ),
            if (e.daysLeft <= 5) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppTheme.accentRed.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.accentRed.withValues(alpha: 0.3))),
                child: Text('⚠️ Exam is very soon! Start revising immediately.', style: GoogleFonts.inter(color: AppTheme.accentRed, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ]),
        )),
        const SizedBox(height: 80),
      ]),
    );
  }
}
