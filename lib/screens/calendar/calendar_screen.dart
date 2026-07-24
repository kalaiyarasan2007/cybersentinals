import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:student_insight_ai/core/models/models.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/providers/providers.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});
  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final eventsNotifier = ref.watch(calendarEventsProvider.notifier);
    final allEvents = ref.watch(calendarEventsProvider);
    final eventMap = eventsNotifier.eventMap;
    final selectedEvents = eventsNotifier.forDate(_selectedDay);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
        elevation: 0,
        title: Text('Calendar',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
        actions: [
          // Format toggle
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () => setState(() => _calendarFormat =
                  _calendarFormat == CalendarFormat.month
                      ? CalendarFormat.week
                      : CalendarFormat.month),
              child: Text(
                _calendarFormat == CalendarFormat.month ? 'Week' : 'Month',
                style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            color: AppTheme.primaryBlue,
            iconSize: 28,
            onPressed: () => _showAddEventSheet(context, isDark, _selectedDay),
          ),
        ],
      ),
      body: Column(children: [
        // ─── Calendar Widget ──────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: TableCalendar<CalendarEvent>(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: (day) {
              final key = DateTime.utc(day.year, day.month, day.day);
              return eventMap[key] ?? [];
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) => setState(() => _calendarFormat = format),
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: true,
              selectedDecoration: const BoxDecoration(
                color: AppTheme.primaryBlue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppTheme.accentRed,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 3,
              markerSize: 5,
              markerMargin: const EdgeInsets.symmetric(horizontal: 1),
              defaultTextStyle: GoogleFonts.inter(
                color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
              ),
              weekendTextStyle: GoogleFonts.inter(
                color: AppTheme.accentRed,
              ),
              outsideTextStyle: GoogleFonts.inter(
                color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
              ),
              selectedTextStyle: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              todayTextStyle: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
              ),
              leftChevronIcon: Icon(Icons.chevron_left_rounded,
                  color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
              rightChevronIcon: Icon(Icons.chevron_right_rounded,
                  color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
              weekendStyle: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.accentRed),
            ),
          ),
        ),

        // ─── Legend ───────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legend('Exam', AppTheme.accentRed),
              _legend('Deadline', AppTheme.accentOrange),
              _legend('Event', AppTheme.primaryBlue),
              _legend('Holiday', AppTheme.accentGreen),
            ],
          ),
        ),

        // ─── Selected Day Events ───────────────────────────────────────────
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(
                  DateFormat('EEEE, d MMMM').format(_selectedDay),
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
                ),
                const Spacer(),
                if (selectedEvents.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text('${selectedEvents.length} events',
                        style: GoogleFonts.inter(
                            color: AppTheme.primaryBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
              ]),
              const SizedBox(height: 10),
              if (selectedEvents.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.event_available_rounded, size: 48,
                          color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                      const SizedBox(height: 10),
                      Text('No events on this day',
                          style: GoogleFonts.inter(
                              color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
                      const SizedBox(height: 4),
                      TextButton.icon(
                        onPressed: () => _showAddEventSheet(context, isDark, _selectedDay),
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: Text('Add Event', style: GoogleFonts.inter(fontSize: 13)),
                      ),
                    ]),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedEvents.length,
                    itemBuilder: (_, i) => _EventCard(
                        event: selectedEvents[i], isDark: isDark),
                  ),
                ),
            ]),
          ),
        ),
      ]),
      // ─── Upcoming Events FAB ───────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUpcomingEvents(context, isDark, allEvents),
        icon: const Icon(Icons.list_rounded),
        label: Text('Upcoming', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _legend(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Row(children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  void _showAddEventSheet(BuildContext context, bool isDark, DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddEventSheet(isDark: isDark, initialDate: date),
    );
  }

  void _showUpcomingEvents(BuildContext context, bool isDark, List<CalendarEvent> events) {
    final upcoming = events
        .where((e) => e.date.isAfter(DateTime.now().subtract(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Upcoming Events',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: upcoming.length,
                itemBuilder: (_, i) => _EventCard(event: upcoming[i], isDark: isDark),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─── Event Card ───────────────────────────────────────────────────────────────
class _EventCard extends ConsumerWidget {
  final CalendarEvent event;
  final bool isDark;
  const _EventCard({required this.event, required this.isDark});

  static const Map<String, IconData> _typeIcons = {
    'exam': Icons.quiz_rounded,
    'deadline': Icons.timer_rounded,
    'event': Icons.event_rounded,
    'holiday': Icons.beach_access_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysLeft = event.date.difference(DateTime.now()).inDays;
    return Dismissible(
      key: Key(event.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => ref.read(calendarEventsProvider.notifier).delete(event.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.accentRed.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: AppTheme.accentRed),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: event.color.withValues(alpha: 0.3)),
          boxShadow: isDark
              ? []
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
                color: event.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(_typeIcons[event.type] ?? Icons.event_rounded,
                color: event.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(event.title,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
              if (event.description != null)
                Text(event.description!,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
              const SizedBox(height: 4),
              Text(DateFormat('EEE, d MMM yyyy').format(event.date),
                  style: GoogleFonts.inter(fontSize: 11, color: event.color, fontWeight: FontWeight.w500)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: event.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                daysLeft == 0
                    ? 'Today'
                    : daysLeft == 1
                        ? 'Tomorrow'
                        : '$daysLeft days',
                style: GoogleFonts.inter(
                    fontSize: 11, color: event.color, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  color: event.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6)),
              child: Text(event.type.toUpperCase(),
                  style: GoogleFonts.inter(fontSize: 9, color: event.color, fontWeight: FontWeight.bold)),
            ),
          ]),
        ]),
      ),
    );
  }
}

// ─── Add Event Sheet ─────────────────────────────────────────────────────────
class _AddEventSheet extends ConsumerStatefulWidget {
  final bool isDark;
  final DateTime initialDate;
  const _AddEventSheet({required this.isDark, required this.initialDate});
  @override
  ConsumerState<_AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends ConsumerState<_AddEventSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _type = 'event';
  late DateTime _date;

  final List<Map<String, dynamic>> _types = [
    {'label': 'Exam', 'value': 'exam', 'icon': Icons.quiz_rounded, 'color': const Color(0xFFFF6584)},
    {'label': 'Deadline', 'value': 'deadline', 'icon': Icons.timer_rounded, 'color': const Color(0xFFFF9F43)},
    {'label': 'Event', 'value': 'event', 'icon': Icons.event_rounded, 'color': const Color(0xFF1A73E8)},
    {'label': 'Holiday', 'value': 'holiday', 'icon': Icons.beach_access_rounded, 'color': const Color(0xFF34A853)},
  ];

  @override
  void initState() {
    super.initState();
    _date = widget.initialDate;
  }

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
            Text('Add Important Date',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
            const SizedBox(height: 20),

            // Event Type
            Text('Type',
                style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: widget.isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
            const SizedBox(height: 8),
            Row(children: _types.map((t) {
              final isSelected = _type == t['value'];
              final color = t['color'] as Color;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _type = t['value']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isSelected ? color : (widget.isDark ? AppTheme.borderDark : AppTheme.borderLight)),
                    ),
                    child: Column(children: [
                      Icon(t['icon'] as IconData,
                          color: isSelected ? color : (widget.isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                          size: 20),
                      const SizedBox(height: 4),
                      Text(t['label'] as String,
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? color : (widget.isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight))),
                    ]),
                  ),
                ),
              );
            }).toList()),
            const SizedBox(height: 16),

            TextFormField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                labelText: 'Title',
                prefixIcon: const Icon(Icons.title_rounded),
                filled: true,
                fillColor: widget.isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              style: GoogleFonts.inter(),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _descCtrl,
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                prefixIcon: const Icon(Icons.notes_rounded),
                filled: true,
                fillColor: widget.isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              style: GoogleFonts.inter(),
            ),
            const SizedBox(height: 12),

            // Date picker
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: widget.isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.isDark ? AppTheme.borderDark : AppTheme.borderLight),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today_rounded, color: AppTheme.primaryBlue, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat('EEEE, d MMMM yyyy').format(_date),
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: widget.isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.primaryBlue),
                ]),
              ),
            ),
            const SizedBox(height: 24),

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
                child: Text('Add to Calendar',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final selectedType = _types.firstWhere((t) => t['value'] == _type);
    ref.read(calendarEventsProvider.notifier).add(CalendarEvent(
      id: const Uuid().v4(),
      title: _titleCtrl.text.trim(),
      type: _type,
      date: _date,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      color: selectedType['color'] as Color,
    ));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }
}
