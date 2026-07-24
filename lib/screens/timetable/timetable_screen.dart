import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:student_insight_ai/core/models/models.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/providers/providers.dart';

class TimetableScreen extends ConsumerStatefulWidget {
  const TimetableScreen({super.key});
  @override
  ConsumerState<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends ConsumerState<TimetableScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    final todayIndex = DateTime.now().weekday - 1;
    final initialIndex = todayIndex.clamp(0, 5);
    _tab = TabController(length: 6, vsync: this, initialIndex: initialIndex);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
        elevation: 0,
        title: Text('Timetable',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            color: AppTheme.primaryBlue,
            iconSize: 28,
            onPressed: () => _showAddEntrySheet(context, isDark),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 13),
          tabs: _days.map((d) => Tab(text: d)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: List.generate(6, (i) => _DayView(dayIndex: i, isDark: isDark)),
      ),
    );
  }

  void _showAddEntrySheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddTimetableSheet(isDark: isDark),
    );
  }
}

class _DayView extends ConsumerWidget {
  final int dayIndex;
  final bool isDark;
  const _DayView({required this.dayIndex, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(timetableProvider.notifier).forDay(dayIndex);

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_rounded, size: 64,
                color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
            const SizedBox(height: 16),
            Text('No classes scheduled',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
            const SizedBox(height: 8),
            Text('Tap + to add a class',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final e = entries[index];
        return _TimetableCard(entry: e, isDark: isDark);
      },
    );
  }
}

class _TimetableCard extends ConsumerWidget {
  final TimetableEntry entry;
  final bool isDark;
  const _TimetableCard({required this.entry, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => ref.read(timetableProvider.notifier).delete(entry.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.accentRed.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_rounded, color: AppTheme.accentRed),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: AppTheme.cardDecoration(isDark: isDark),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Time column
              Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                decoration: BoxDecoration(
                  color: entry.color.withValues(alpha: 0.08),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(entry.startTime,
                      style: GoogleFonts.inter(
                          fontSize: 13, fontWeight: FontWeight.bold, color: entry.color)),
                  const SizedBox(height: 4),
                  Container(height: 1, color: entry.color.withValues(alpha: 0.3)),
                  const SizedBox(height: 4),
                  Text(entry.endTime,
                      style: GoogleFonts.inter(
                          fontSize: 11, color: entry.color.withValues(alpha: 0.8))),
                ]),
              ),
              // Divider
              Container(width: 3, color: entry.color),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                          color: entry.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(entry.icon, color: entry.color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(entry.subject,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(children: [
                          Icon(Icons.tag_rounded, size: 12,
                              color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                          const SizedBox(width: 2),
                          Text(entry.code,
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
                          const SizedBox(width: 10),
                          Icon(Icons.room_rounded, size: 12,
                              color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                          const SizedBox(width: 2),
                          Text(entry.room,
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
                        ]),
                      ]),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Add Timetable Entry Sheet ────────────────────────────────────────────────
class _AddTimetableSheet extends ConsumerStatefulWidget {
  final bool isDark;
  const _AddTimetableSheet({required this.isDark});
  @override
  ConsumerState<_AddTimetableSheet> createState() => _AddTimetableSheetState();
}

class _AddTimetableSheetState extends ConsumerState<_AddTimetableSheet> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _roomCtrl = TextEditingController();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  int _selectedDay = DateTime.now().weekday <= 6 ? DateTime.now().weekday - 1 : 0;
  Color _selectedColor = const Color(0xFF1A73E8);
  IconData _selectedIcon = Icons.book_rounded;

  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  final List<Color> _colors = [
    const Color(0xFF1A73E8), const Color(0xFF34A853), const Color(0xFFFF6584),
    const Color(0xFFFF9F43), const Color(0xFF6C63FF), const Color(0xFF54A0FF),
    const Color(0xFFFECA57), const Color(0xFF00BCD4),
  ];
  final List<IconData> _icons = [
    Icons.book_rounded, Icons.computer_rounded, Icons.storage_rounded,
    Icons.memory_rounded, Icons.wifi_rounded, Icons.code_rounded,
    Icons.psychology_rounded, Icons.account_tree_rounded, Icons.science_rounded,
    Icons.calculate_rounded, Icons.language_rounded, Icons.hardware_rounded,
  ];

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: BoxDecoration(
        color: widget.isDark ? AppTheme.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: widget.isDark ? AppTheme.borderDark : AppTheme.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Add Class',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
            const SizedBox(height: 20),

            // Subject Name
            TextFormField(
              controller: _subjectCtrl,
              decoration: InputDecoration(
                labelText: 'Subject Name',
                prefixIcon: const Icon(Icons.book_rounded),
                filled: true,
                fillColor: widget.isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              style: GoogleFonts.inter(),
            ),
            const SizedBox(height: 12),

            // Code and Room
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _codeCtrl,
                  decoration: InputDecoration(
                    labelText: 'Code',
                    prefixIcon: const Icon(Icons.tag_rounded),
                    filled: true,
                    fillColor: widget.isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  style: GoogleFonts.inter(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _roomCtrl,
                  decoration: InputDecoration(
                    labelText: 'Room',
                    prefixIcon: const Icon(Icons.room_rounded),
                    filled: true,
                    fillColor: widget.isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  style: GoogleFonts.inter(),
                ),
              ),
            ]),
            const SizedBox(height: 12),

            // Day selector
            Text('Day',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
            const SizedBox(height: 8),
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => setState(() => _selectedDay = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedDay == i
                          ? AppTheme.primaryBlue
                          : (widget.isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _selectedDay == i ? AppTheme.primaryBlue : AppTheme.borderLight,
                      ),
                    ),
                    child: Text(_days[i].substring(0, 3),
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _selectedDay == i
                                ? Colors.white
                                : (widget.isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight))),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time picker
            Row(children: [
              Expanded(
                child: _timeTile('Start Time', _startTime, (t) => setState(() => _startTime = t), widget.isDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _timeTile('End Time', _endTime, (t) => setState(() => _endTime = t), widget.isDark),
              ),
            ]),
            const SizedBox(height: 16),

            // Color picker
            Text('Color',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _colors.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => setState(() => _selectedColor = _colors[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: _colors[i],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == _colors[i] ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: _selectedColor == _colors[i]
                          ? [BoxShadow(color: _colors[i].withValues(alpha: 0.5), blurRadius: 8)]
                          : [],
                    ),
                    child: _selectedColor == _colors[i]
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Icon picker
            Text('Icon',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _icons.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => setState(() => _selectedIcon = _icons[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: _selectedIcon == _icons[i]
                          ? _selectedColor.withValues(alpha: 0.15)
                          : (widget.isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedIcon == _icons[i] ? _selectedColor : Colors.transparent,
                      ),
                    ),
                    child: Icon(_icons[i],
                        color: _selectedIcon == _icons[i]
                            ? _selectedColor
                            : (widget.isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                        size: 22),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text('Add to Timetable',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _timeTile(String label, TimeOfDay time, Function(TimeOfDay) onPick, bool isDark) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: time);
        if (picked != null) onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppTheme.borderDark : AppTheme.borderLight),
        ),
        child: Row(children: [
          Icon(Icons.schedule_rounded, size: 18,
              color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
            Text(_fmt(time), style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
          ]),
        ]),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final entry = TimetableEntry(
      id: const Uuid().v4(),
      subject: _subjectCtrl.text.trim(),
      code: _codeCtrl.text.trim().toUpperCase(),
      room: _roomCtrl.text.trim(),
      startTime: _fmt(_startTime),
      endTime: _fmt(_endTime),
      dayIndex: _selectedDay,
      color: _selectedColor,
      icon: _selectedIcon,
    );
    ref.read(timetableProvider.notifier).add(entry);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Class added to ${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][_selectedDay]} timetable!',
            style: GoogleFonts.inter()),
        backgroundColor: AppTheme.accentGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _codeCtrl.dispose();
    _roomCtrl.dispose();
    super.dispose();
  }
}
