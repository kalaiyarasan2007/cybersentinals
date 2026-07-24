import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_insight_ai/core/models/models.dart';
import 'package:student_insight_ai/core/data/sample_data.dart';
import 'package:student_insight_ai/repositories/auth_repository.dart';
import 'package:student_insight_ai/services/ai_engine.dart';

// ─── Persistence Service ───────────────────────────────────────────────────────
class PersistenceService {
  static const String _studentKey = 'user_student_data';
  static const String _subjectsKey = 'user_subjects_data';
  static const String _timetableKey = 'user_timetable_data';
  static const String _skillsKey = 'user_skills_data';

  static Future<void> saveStudent(StudentModel s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studentKey, jsonEncode(s.toMap()));
  }

  static Future<StudentModel?> loadStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_studentKey);
    if (data == null) return null;
    return StudentModel.fromMap(jsonDecode(data));
  }

  static Future<void> saveSubjects(List<SubjectModel> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final list = subjects.map((s) => s.toMap()).toList();
    await prefs.setString(_subjectsKey, jsonEncode(list));
  }

  static Future<List<SubjectModel>?> loadSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_subjectsKey);
    if (data == null) return null;
    final List<dynamic> list = jsonDecode(data);
    return list.map((item) => SubjectModel.fromMap(item)).toList();
  }

  static Future<void> saveTimetable(List<TimetableEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final list = entries.map((e) => e.toMap()).toList();
    await prefs.setString(_timetableKey, jsonEncode(list));
  }

  static Future<List<TimetableEntry>?> loadTimetable() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_timetableKey);
    if (data == null) return null;
    final List<dynamic> list = jsonDecode(data);
    return list.map((item) => TimetableEntry.fromMap(item)).toList();
  }

  static Future<void> saveSkills(List<SkillModel> skills) async {
    final prefs = await SharedPreferences.getInstance();
    final list = skills.map((s) => s.toMap()).toList();
    await prefs.setString(_skillsKey, jsonEncode(list));
  }

  static Future<List<SkillModel>?> loadSkills() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_skillsKey);
    if (data == null) return null;
    final List<dynamic> list = jsonDecode(data);
    return list.map((item) => SkillModel.fromMap(item)).toList();
  }
}

// ─── Auth Providers ────────────────────────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());

final currentUserProvider = StateProvider<StudentModel?>((ref) => null);

final initializationProvider = FutureProvider<void>((ref) async {
  try {
    // Load student data from persistence first
    final persistedStudent = await PersistenceService.loadStudent();
    if (persistedStudent != null) {
      ref.read(currentUserProvider.notifier).state = persistedStudent;
    } else {
      final studentData = await ref.read(authRepositoryProvider).getCurrentUser();
      ref.read(currentUserProvider.notifier).state = studentData;
      if (studentData != null) PersistenceService.saveStudent(studentData);
    }
  } catch (_) {}
});

final isLoggedInProvider = Provider<bool>((ref) => ref.watch(currentUserProvider) != null);

// ─── Theme Provider ────────────────────────────────────────────────────────────
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('dark_mode') ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', state);
  }
}

// ─── Nav Provider ─────────────────────────────────────────────────────────────
final navIndexProvider = StateProvider<int>((ref) => 0);

// ─── Student Provider ──────────────────────────────────────────────────────────
final studentProvider = StateNotifierProvider<StudentNotifier, StudentModel>((ref) {
  return StudentNotifier(ref.watch(currentUserProvider) ?? SampleData.student);
});

class StudentNotifier extends StateNotifier<StudentModel> {
  StudentNotifier(super.s);
  void update(StudentModel s) {
    state = s;
    PersistenceService.saveStudent(s);
  }
  void updateField({String? name, String? bio, String? phone, String? department, String? semester, double? cgpa, double? attendancePercent, double? placementScore, int? codingStreak}) {
    state = state.copyWith(
      name: name, bio: bio, phone: phone, department: department, semester: semester,
      cgpa: cgpa, attendancePercent: attendancePercent, placementScore: placementScore,
      codingStreak: codingStreak,
    );
    PersistenceService.saveStudent(state);
  }
}

// ─── Subjects Provider ────────────────────────────────────────────────────────
final subjectsProvider = StateNotifierProvider<SubjectsNotifier, List<SubjectModel>>((ref) => SubjectsNotifier());

class SubjectsNotifier extends StateNotifier<List<SubjectModel>> {
  SubjectsNotifier() : super([]) { _load(); }

  Future<void> _load() async {
    final loaded = await PersistenceService.loadSubjects();
    if (loaded != null) {
      state = loaded;
    } else {
      state = SampleData.subjects; // Initial default
      PersistenceService.saveSubjects(state);
    }
  }

  void add(SubjectModel s) {
    state = [...state, s];
    PersistenceService.saveSubjects(state);
  }

  void delete(String id) {
    state = state.where((s) => s.id != id).toList();
    PersistenceService.saveSubjects(state);
  }

  void updateMarks(String id, double marks) {
    state = [for (final s in state) if (s.id == id) s.copyWith(marks: marks) else s];
    PersistenceService.saveSubjects(state);
  }

  void updateAttendance(String id, double percent) {
    state = [for (final s in state) if (s.id == id) s.copyWith(attendancePercent: percent) else s];
    PersistenceService.saveSubjects(state);
  }

  void updateCredits(String id, int credits) {
    state = [for (final s in state) if (s.id == id) s.copyWith(credits: credits) else s];
    PersistenceService.saveSubjects(state);
  }
}

// ─── Skills Provider ──────────────────────────────────────────────────────────
final skillsProvider = StateNotifierProvider<SkillsNotifier, List<SkillModel>>((ref) => SkillsNotifier());

class SkillsNotifier extends StateNotifier<List<SkillModel>> {
  SkillsNotifier() : super(SampleData.skills) { _load(); }

  Future<void> _load() async {
    final loaded = await PersistenceService.loadSkills();
    if (loaded != null) state = loaded;
  }

  void updateProficiency(String id, double p) {
    state = [for (final s in state) if (s.id == id) s.copyWith(proficiency: p) else s];
    PersistenceService.saveSkills(state);
  }

  void add(SkillModel s) {
    state = [...state, s];
    PersistenceService.saveSkills(state);
  }

  void delete(String id) {
    state = state.where((s) => s.id != id).toList();
    PersistenceService.saveSkills(state);
  }
}

// ─── Assignments Provider ─────────────────────────────────────────────────────
final assignmentsProvider = StateNotifierProvider<AssignmentNotifier, List<AssignmentModel>>((ref) => AssignmentNotifier());

class AssignmentNotifier extends StateNotifier<List<AssignmentModel>> {
  AssignmentNotifier() : super(SampleData.assignments);
  void toggleDone(String id) {
    state = [for (final a in state) if (a.id == id) a.copyWith(isDone: !a.isDone) else a];
  }
  void add(AssignmentModel a) => state = [...state, a];
  void delete(String id) => state = state.where((a) => a.id != id).toList();
}

// ─── Tasks Provider ───────────────────────────────────────────────────────────
final tasksProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) => TaskNotifier());

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier() : super(SampleData.tasks);
  void toggleDone(String id) {
    state = [for (final t in state) if (t.id == id) t.copyWith(isDone: !t.isDone) else t];
  }
  void add(TaskModel t) => state = [...state, t];
  void delete(String id) => state = state.where((t) => t.id != id).toList();
}

// ─── AI Chat Provider ─────────────────────────────────────────────────────────
final aiChatProvider = StateNotifierProvider<AIChatNotifier, List<ChatMessage>>((ref) => AIChatNotifier());

class AIChatNotifier extends StateNotifier<List<ChatMessage>> {
  AIChatNotifier() : super(SampleData.initialChats);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void addMessage(String text, bool isUser) {
    state = [...state, ChatMessage(id: DateTime.now().millisecondsSinceEpoch.toString(), text: text, isUser: isUser, time: DateTime.now())];
  }

  Future<void> sendMessage(String text) async {
    addMessage(text, true);
    _isLoading = true;
    await Future.delayed(const Duration(milliseconds: 1400));
    addMessage(AIResponseEngine.generate(text), false);
    _isLoading = false;
  }
}

// ─── Habits Provider ──────────────────────────────────────────────────────────
final habitsProvider = StateNotifierProvider<HabitNotifier, List<HabitModel>>((ref) => HabitNotifier());

class HabitNotifier extends StateNotifier<List<HabitModel>> {
  HabitNotifier() : super(SampleData.habits);
  void toggle(String id, int dayIndex) {
    state = [
      for (final h in state)
        if (h.id == id)
          h.copyWith(
            weekProgress: List<bool>.from(h.weekProgress)..[dayIndex] = !h.weekProgress[dayIndex],
            currentStreak: h.weekProgress[dayIndex] ? h.currentStreak - 1 : h.currentStreak + 1,
          )
        else h
    ];
  }
  void add(HabitModel h) => state = [...state, h];
  void delete(String id) => state = state.where((h) => h.id != id).toList();
}

// ─── Pomodoro Provider ────────────────────────────────────────────────────────
final pomodoroProvider = StateNotifierProvider<PomodoroNotifier, PomodoroState>((ref) => PomodoroNotifier());

class PomodoroState {
  final int minutes, seconds, completedSessions;
  final bool isRunning, isBreak;
  const PomodoroState({this.minutes = 25, this.seconds = 0, this.completedSessions = 0, this.isRunning = false, this.isBreak = false});
  PomodoroState copyWith({int? minutes, int? seconds, int? completedSessions, bool? isRunning, bool? isBreak}) =>
      PomodoroState(minutes: minutes ?? this.minutes, seconds: seconds ?? this.seconds, completedSessions: completedSessions ?? this.completedSessions, isRunning: isRunning ?? this.isRunning, isBreak: isBreak ?? this.isBreak);
}

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  PomodoroNotifier() : super(const PomodoroState());
  void toggle() => state = state.copyWith(isRunning: !state.isRunning);
  void reset() => state = const PomodoroState();
  void tick() {
    if (!state.isRunning) return;
    if (state.seconds > 0) {
      state = state.copyWith(seconds: state.seconds - 1);
    } else if (state.minutes > 0) {
      state = state.copyWith(minutes: state.minutes - 1, seconds: 59);
    } else {
      if (state.isBreak) {
        state = const PomodoroState(isRunning: true);
      } else {
        state = state.copyWith(minutes: 5, seconds: 0, isBreak: true, completedSessions: state.completedSessions + 1);
      }
    }
  }
  void setDuration(int mins) => state = PomodoroState(minutes: mins);
}

// ─── Notifications Provider ───────────────────────────────────────────────────
final notificationsProvider = StateProvider<List<AppNotification>>((ref) => SampleData.notifications);

// ─── Timetable Provider ───────────────────────────────────────────────────────
final timetableProvider = StateNotifierProvider<TimetableNotifier, List<TimetableEntry>>((ref) => TimetableNotifier());

class TimetableNotifier extends StateNotifier<List<TimetableEntry>> {
  TimetableNotifier() : super([]) { _load(); }

  Future<void> _load() async {
    final loaded = await PersistenceService.loadTimetable();
    if (loaded != null) state = loaded;
  }

  void add(TimetableEntry entry) {
    state = [...state, entry];
    PersistenceService.saveTimetable(state);
  }

  void delete(String id) {
    state = state.where((e) => e.id != id).toList();
    PersistenceService.saveTimetable(state);
  }

  void update(TimetableEntry updated) {
    state = [for (final e in state) if (e.id == updated.id) updated else e];
    PersistenceService.saveTimetable(state);
  }

  List<TimetableEntry> forDay(int dayIndex) =>
      state.where((e) => e.dayIndex == dayIndex).toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

  List<TimetableEntry> forToday() {
    final today = DateTime.now().weekday;
    if (today == 7) return [];
    return forDay(today - 1);
  }
}

// ─── Calendar Events Provider ─────────────────────────────────────────────────
final calendarEventsProvider = StateNotifierProvider<CalendarEventsNotifier, List<CalendarEvent>>(
    (ref) => CalendarEventsNotifier());

class CalendarEventsNotifier extends StateNotifier<List<CalendarEvent>> {
  CalendarEventsNotifier() : super(_defaultEvents());

  static List<CalendarEvent> _defaultEvents() {
    final now = DateTime.now();
    return [
      CalendarEvent(id: 'e1', title: 'DBMS Internal Exam', type: 'exam', date: now.add(const Duration(days: 4)), description: 'Units 1-3', color: const Color(0xFFFF6584)),
      CalendarEvent(id: 'e2', title: 'OS Internal Exam', type: 'exam', date: now.add(const Duration(days: 7)), description: 'Full Syllabus', color: const Color(0xFFFF6584)),
      CalendarEvent(id: 'e3', title: 'CN Assignment Deadline', type: 'deadline', date: now.add(const Duration(days: 3)), description: 'TCP/IP Protocol Analysis', color: const Color(0xFFFF9F43)),
      CalendarEvent(id: 'e4', title: 'Tech Fest 2026', type: 'event', date: now.add(const Duration(days: 10)), description: 'Annual College Tech Festival', color: const Color(0xFF1A73E8)),
      CalendarEvent(id: 'e5', title: 'Diwali Holiday', type: 'holiday', date: now.add(const Duration(days: 15)), description: 'College Holiday', color: const Color(0xFF34A853)),
      CalendarEvent(id: 'e6', title: 'ML Assignment Due', type: 'deadline', date: now.add(const Duration(days: 5)), description: 'Linear Regression Assignment', color: const Color(0xFFFF9F43)),
      CalendarEvent(id: 'e7', title: 'Placement Drive - TCS', type: 'event', date: now.add(const Duration(days: 20)), description: 'On-campus placement', color: const Color(0xFF1A73E8)),
    ];
  }

  void add(CalendarEvent event) => state = [...state, event];
  void delete(String id) => state = state.where((e) => e.id != id).toList();

  List<CalendarEvent> forDate(DateTime date) => state.where((e) =>
    e.date.year == date.year && e.date.month == date.month && e.date.day == date.day).toList();

  Map<DateTime, List<CalendarEvent>> get eventMap {
    final map = <DateTime, List<CalendarEvent>>{};
    for (final e in state) {
      final key = DateTime.utc(e.date.year, e.date.month, e.date.day);
      map[key] = [...(map[key] ?? []), e];
    }
    return map;
  }
}

// ─── Profile Photo Provider ───────────────────────────────────────────────────
final profilePhotoProvider = StateNotifierProvider<ProfilePhotoNotifier, String?>((ref) => ProfilePhotoNotifier());

class ProfilePhotoNotifier extends StateNotifier<String?> {
  ProfilePhotoNotifier() : super(null) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('profile_photo_path');
  }

  Future<void> setPhoto(String path) async {
    state = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_photo_path', path);
  }

  Future<void> clearPhoto() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_photo_path');
  }
}
