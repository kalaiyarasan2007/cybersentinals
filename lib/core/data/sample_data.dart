import 'package:flutter/material.dart';
import '../models/models.dart';

class SampleData {
  // ─── Student ─────────────────────────────────────────────────────────────────
  static final StudentModel student = StudentModel(
    uid: 'sample123',
    name: 'Kalaiyarasan K',
    rollNo: '21CS045',
    department: 'Computer Science',
    semester: '6th Semester',
    collegeName: 'Anna University',
    email: 'kalai@example.com',
    avatarInitials: 'K',
    bio: 'Passionate CS student | Competitive programmer | Placement aspirant',
    phone: '+91 9876543210',
    photoUrl: null,
    provider: 'local',
    cgpa: 8.4,
    predictedCgpa: 8.7,
    attendancePercent: 78.5,
    placementScore: 72.0,
    productivityScore: 85.0,
    codingStreak: 14,
    assignmentsPending: 3,
    createdAt: DateTime.now().subtract(const Duration(days: 180)),
    lastLogin: DateTime.now(),
    profileCompleted: true,
  );

  // ─── Subjects ────────────────────────────────────────────────────────────────
  static const List<SubjectModel> subjects = [
    SubjectModel(id: 's1', name: 'Data Structures & Algorithms', code: 'CS301', marks: 72, maxMarks: 100, attendancePercent: 88, color: Color(0xFF6C63FF), icon: Icons.account_tree_rounded),
    SubjectModel(id: 's2', name: 'Operating Systems', code: 'CS302', marks: 85, maxMarks: 100, attendancePercent: 92, color: Color(0xFF34A853), icon: Icons.memory_rounded),
    SubjectModel(id: 's3', name: 'Database Management', code: 'CS303', marks: 61, maxMarks: 100, attendancePercent: 78, color: Color(0xFFFF9F43), icon: Icons.storage_rounded),
    SubjectModel(id: 's4', name: 'Computer Networks', code: 'CS304', marks: 78, maxMarks: 100, attendancePercent: 82, color: Color(0xFF54A0FF), icon: Icons.wifi_rounded),
    SubjectModel(id: 's5', name: 'Software Engineering', code: 'CS305', marks: 90, maxMarks: 100, attendancePercent: 95, color: Color(0xFFFF6584), icon: Icons.code_rounded),
    SubjectModel(id: 's6', name: 'Machine Learning', code: 'CS306', marks: 68, maxMarks: 100, attendancePercent: 76, color: Color(0xFFFECA57), icon: Icons.psychology_rounded),
  ];

  // ─── Assignments ─────────────────────────────────────────────────────────────
  static final List<AssignmentModel> assignments = [
    AssignmentModel(id: 'a1', title: 'OS Lab Report - Scheduling Algorithms', subject: 'Operating Systems', dueDate: DateTime.now().add(const Duration(days: 1)), priority: 'High'),
    AssignmentModel(id: 'a2', title: 'CN Assignment - TCP/IP Protocol Analysis', subject: 'Computer Networks', dueDate: DateTime.now().add(const Duration(days: 3)), priority: 'Medium'),
    AssignmentModel(id: 'a3', title: 'DBMS Mini Project - Library System', subject: 'Database Management', dueDate: DateTime.now().add(const Duration(days: 6)), priority: 'High'),
    AssignmentModel(id: 'a4', title: 'DS Lab - Binary Tree Traversal', subject: 'Data Structures', dueDate: DateTime.now().add(const Duration(days: 10)), priority: 'Low', isDone: true),
    AssignmentModel(id: 'a5', title: 'SE Documentation - SRS Report', subject: 'Software Engineering', dueDate: DateTime.now().add(const Duration(days: 14)), priority: 'Medium'),
    AssignmentModel(id: 'a6', title: 'ML Assignment - Linear Regression', subject: 'Machine Learning', dueDate: DateTime.now().add(const Duration(days: 5)), priority: 'High'),
  ];

  // ─── Tasks ───────────────────────────────────────────────────────────────────
  static final List<TaskModel> tasks = [
    TaskModel(id: 't1', title: 'Study DS - Binary Trees', category: 'Study', date: DateTime.now(), time: const TimeOfDay(hour: 9, minute: 0), isDone: true),
    TaskModel(id: 't2', title: 'Complete OS Lab Report', category: 'Assignment', date: DateTime.now(), time: const TimeOfDay(hour: 11, minute: 30)),
    TaskModel(id: 't3', title: 'LeetCode - 2 Problems', category: 'Coding', date: DateTime.now(), time: const TimeOfDay(hour: 14, minute: 0)),
    TaskModel(id: 't4', title: 'Revise CN - Network Layer', category: 'Study', date: DateTime.now(), time: const TimeOfDay(hour: 16, minute: 0)),
    TaskModel(id: 't5', title: 'Mock Interview Practice', category: 'Placement', date: DateTime.now().add(const Duration(days: 1)), time: const TimeOfDay(hour: 10, minute: 0)),
    TaskModel(id: 't6', title: 'DBMS Mini Project Work', category: 'Assignment', date: DateTime.now().add(const Duration(days: 1)), time: const TimeOfDay(hour: 15, minute: 0)),
    TaskModel(id: 't7', title: 'ML Assignment Submission', category: 'Study', date: DateTime.now().add(const Duration(days: 2)), time: const TimeOfDay(hour: 9, minute: 0)),
    TaskModel(id: 't8', title: 'Company Research - TCS', category: 'Placement', date: DateTime.now().add(const Duration(days: 2)), time: const TimeOfDay(hour: 19, minute: 0)),
  ];

  // ─── Weekly Data ─────────────────────────────────────────────────────────────
  static const List<WeeklyData> weeklyData = [
    WeeklyData(day: 'Mon', studyHours: 4.5, productivityScore: 72),
    WeeklyData(day: 'Tue', studyHours: 6.0, productivityScore: 85),
    WeeklyData(day: 'Wed', studyHours: 3.5, productivityScore: 60),
    WeeklyData(day: 'Thu', studyHours: 7.0, productivityScore: 90),
    WeeklyData(day: 'Fri', studyHours: 5.5, productivityScore: 78),
    WeeklyData(day: 'Sat', studyHours: 8.0, productivityScore: 95),
    WeeklyData(day: 'Sun', studyHours: 2.0, productivityScore: 45),
  ];

  // ─── Semester Trend ───────────────────────────────────────────────────────────
  static const List<SemesterData> semesterTrend = [
    SemesterData(semester: 'S1', cgpa: 7.8),
    SemesterData(semester: 'S2', cgpa: 8.0),
    SemesterData(semester: 'S3', cgpa: 8.2),
    SemesterData(semester: 'S4', cgpa: 7.9),
    SemesterData(semester: 'S5', cgpa: 8.4),
    SemesterData(semester: 'S6', cgpa: 8.7),
  ];

  // ─── Today's Schedule ────────────────────────────────────────────────────────
  static const List<ScheduleModel> todaysSchedule = [
    ScheduleModel(title: 'Data Structures Lab', time: '09:00 - 11:00 AM', room: 'Lab 3', color: Color(0xFF1A73E8), icon: Icons.computer_rounded),
    ScheduleModel(title: 'Database Systems', time: '11:15 AM - 12:15 PM', room: 'Room 402', color: Color(0xFF34A853), icon: Icons.storage_rounded),
    ScheduleModel(title: 'Operating Systems', time: '01:30 - 02:30 PM', room: 'Room 405', color: Color(0xFFF9AB00), icon: Icons.memory_rounded),
    ScheduleModel(title: 'Machine Learning', time: '02:45 - 04:00 PM', room: 'Room 410', color: Color(0xFF9B59B6), icon: Icons.psychology_rounded),
  ];

  // ─── Upcoming Exams ───────────────────────────────────────────────────────────
  static const List<ExamModel> upcomingExams = [
    ExamModel(subject: 'Database Management Systems', date: 'Oct 25, 2026', syllabus: 'Units 1 to 3', daysLeft: 4),
    ExamModel(subject: 'Operating Systems', date: 'Oct 28, 2026', syllabus: 'Full Syllabus', daysLeft: 7),
    ExamModel(subject: 'Computer Networks', date: 'Nov 02, 2026', syllabus: 'Units 1 & 2', daysLeft: 12),
    ExamModel(subject: 'Machine Learning', date: 'Nov 08, 2026', syllabus: 'Units 1, 2, 3', daysLeft: 18),
  ];

  // ─── Habits ───────────────────────────────────────────────────────────────────
  static final List<HabitModel> habits = [
    HabitModel(id: 'h1', title: 'Morning Study', emoji: '📚', category: 'Study', targetDays: 7, currentStreak: 5, bestStreak: 14, weekProgress: [true, true, true, true, true, false, false], color: const Color(0xFF1A73E8)),
    HabitModel(id: 'h2', title: 'Drink 8 Glasses Water', emoji: '💧', category: 'Health', targetDays: 7, currentStreak: 3, bestStreak: 21, weekProgress: [true, true, false, true, false, false, false], color: const Color(0xFF34A853)),
    HabitModel(id: 'h3', title: 'LeetCode Daily', emoji: '💻', category: 'Coding', targetDays: 7, currentStreak: 14, bestStreak: 14, weekProgress: [true, true, true, true, true, true, true], color: const Color(0xFF9B59B6)),
    HabitModel(id: 'h4', title: 'Exercise 30 min', emoji: '🏃', category: 'Health', targetDays: 5, currentStreak: 2, bestStreak: 10, weekProgress: [false, true, true, false, false, false, false], color: const Color(0xFFFF6584)),
    HabitModel(id: 'h5', title: 'Read Tech News', emoji: '📰', category: 'Learning', targetDays: 5, currentStreak: 4, bestStreak: 12, weekProgress: [true, true, true, true, false, false, false], color: const Color(0xFFF9AB00)),
  ];

  // ─── Skills ───────────────────────────────────────────────────────────────────
  static const List<SkillModel> skills = [
    SkillModel(name: 'Java', category: 'Programming', proficiency: 0.82, color: Color(0xFFFF6584)),
    SkillModel(name: 'Python', category: 'Programming', proficiency: 0.75, color: Color(0xFF34A853)),
    SkillModel(name: 'Data Structures', category: 'CS Core', proficiency: 0.70, color: Color(0xFF6C63FF)),
    SkillModel(name: 'SQL', category: 'Database', proficiency: 0.65, color: Color(0xFFF9AB00)),
    SkillModel(name: 'System Design', category: 'Architecture', proficiency: 0.45, color: Color(0xFF54A0FF)),
    SkillModel(name: 'React', category: 'Web', proficiency: 0.60, color: Color(0xFF00BCD4)),
    SkillModel(name: 'Communication', category: 'Soft Skills', proficiency: 0.80, color: Color(0xFFFF9F43)),
    SkillModel(name: 'Problem Solving', category: 'Aptitude', proficiency: 0.72, color: Color(0xFF9B59B6)),
  ];

  // ─── AI Features ─────────────────────────────────────────────────────────────
  static const List<AIFeature> aiFeatures = [
    AIFeature(title: 'Study Planner', subtitle: 'AI-powered daily plan', emoji: '📚', color: Color(0xFF6C63FF)),
    AIFeature(title: 'GPA Predictor', subtitle: 'Predict your semester CGPA', emoji: '📊', color: Color(0xFF43B97F)),
    AIFeature(title: 'Burnout Detector', subtitle: 'Monitor your mental wellness', emoji: '💙', color: Color(0xFFFF6584)),
    AIFeature(title: 'Placement Coach', subtitle: 'Interview & resume tips', emoji: '🎯', color: Color(0xFFFF9F43)),
    AIFeature(title: 'Code Analyser', subtitle: 'DSA skill assessment', emoji: '💻', color: Color(0xFF54A0FF)),
    AIFeature(title: 'Career Guide', subtitle: 'Personalized career path', emoji: '🚀', color: Color(0xFFFECA57)),
    AIFeature(title: 'Resume Builder', subtitle: 'AI resume suggestions', emoji: '📄', color: Color(0xFF4A47A3)),
    AIFeature(title: 'Smart Goals', subtitle: 'Set & track SMART goals', emoji: '🏆', color: Color(0xFF26A269)),
  ];

  // ─── Motivational Quotes ──────────────────────────────────────────────────────
  static const List<String> motivationalQuotes = [
    '"Success is not final, failure is not fatal: It is the courage to continue that counts." — Winston Churchill',
    '"Education is the most powerful weapon which you can use to change the world." — Nelson Mandela',
    '"The beautiful thing about learning is that no one can take it away from you." — B.B. King',
    '"Believe you can and you\'re halfway there." — Theodore Roosevelt',
    '"Your time is limited, don\'t waste it living someone else\'s life." — Steve Jobs',
    '"The expert in anything was once a beginner." — Helen Hayes',
    '"It does not matter how slowly you go as long as you do not stop." — Confucius',
    '"Hard work beats talent when talent doesn\'t work hard." — Tim Notke',
  ];

  // ─── Initial Chats ────────────────────────────────────────────────────────────
  static final List<ChatMessage> initialChats = [
    ChatMessage(
      id: '1',
      text: '👋 Hello! I\'m your AI Academic Mentor.\n\nI can help you with:\n• 📚 Study planning\n• 📊 Performance analysis\n• 🎯 Placement preparation\n• 💡 Career guidance\n\nWhat would you like to explore today?',
      isUser: false,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  // ─── Notifications ────────────────────────────────────────────────────────────
  static final List<AppNotification> notifications = [
    AppNotification(id: 'n1', title: '📝 Assignment Due Tomorrow', body: 'OS Lab Report is due tomorrow. Don\'t forget!', type: 'assignment', time: DateTime.now().subtract(const Duration(hours: 1))),
    AppNotification(id: 'n2', title: '⚠️ Low Attendance Alert', body: 'Your DBMS attendance is 78% — below 80%. Attend the next 3 classes.', type: 'attendance', time: DateTime.now().subtract(const Duration(hours: 3))),
    AppNotification(id: 'n3', title: '🔥 Coding Streak', body: 'Great job! You\'ve maintained a 14-day coding streak!', type: 'achievement', time: DateTime.now().subtract(const Duration(hours: 5))),
    AppNotification(id: 'n4', title: '📅 Exam in 4 Days', body: 'DBMS exam is on Oct 25. Start revising Units 1-3 now!', type: 'exam', time: DateTime.now().subtract(const Duration(days: 1))),
  ];

  // ─── Timetable ───────────────────────────────────────────────────────────────
  static const List<TimetableEntry> timetable = [
    // Monday
    TimetableEntry(id: 'tt1', subject: 'Data Structures & Algorithms', code: 'CS301', room: 'Room 301', startTime: '09:00', endTime: '10:00', dayIndex: 0, color: Color(0xFF6C63FF), icon: Icons.account_tree_rounded),
    TimetableEntry(id: 'tt2', subject: 'Operating Systems', code: 'CS302', room: 'Room 405', startTime: '10:15', endTime: '11:15', dayIndex: 0, color: Color(0xFF34A853), icon: Icons.memory_rounded),
    TimetableEntry(id: 'tt3', subject: 'Machine Learning', code: 'CS306', room: 'Lab 2', startTime: '11:30', endTime: '12:30', dayIndex: 0, color: Color(0xFFFECA57), icon: Icons.psychology_rounded),
    // Tuesday
    TimetableEntry(id: 'tt4', subject: 'Database Management', code: 'CS303', room: 'Room 402', startTime: '09:00', endTime: '10:00', dayIndex: 1, color: Color(0xFFFF9F43), icon: Icons.storage_rounded),
    TimetableEntry(id: 'tt5', subject: 'Computer Networks', code: 'CS304', room: 'Room 410', startTime: '10:15', endTime: '11:15', dayIndex: 1, color: Color(0xFF54A0FF), icon: Icons.wifi_rounded),
    TimetableEntry(id: 'tt6', subject: 'Software Engineering', code: 'CS305', room: 'Room 301', startTime: '11:30', endTime: '12:30', dayIndex: 1, color: Color(0xFFFF6584), icon: Icons.code_rounded),
    // Wednesday
    TimetableEntry(id: 'tt7', subject: 'Data Structures & Algorithms', code: 'CS301', room: 'Lab 3', startTime: '09:00', endTime: '11:00', dayIndex: 2, color: Color(0xFF6C63FF), icon: Icons.computer_rounded),
    TimetableEntry(id: 'tt8', subject: 'Machine Learning', code: 'CS306', room: 'Room 410', startTime: '11:30', endTime: '12:30', dayIndex: 2, color: Color(0xFFFECA57), icon: Icons.psychology_rounded),
    // Thursday
    TimetableEntry(id: 'tt9', subject: 'Operating Systems', code: 'CS302', room: 'Room 405', startTime: '09:00', endTime: '10:00', dayIndex: 3, color: Color(0xFF34A853), icon: Icons.memory_rounded),
    TimetableEntry(id: 'tt10', subject: 'Database Management', code: 'CS303', room: 'Lab 1', startTime: '10:15', endTime: '12:15', dayIndex: 3, color: Color(0xFFFF9F43), icon: Icons.storage_rounded),
    // Friday
    TimetableEntry(id: 'tt11', subject: 'Computer Networks', code: 'CS304', room: 'Room 402', startTime: '09:00', endTime: '10:00', dayIndex: 4, color: Color(0xFF54A0FF), icon: Icons.wifi_rounded),
    TimetableEntry(id: 'tt12', subject: 'Software Engineering', code: 'CS305', room: 'Room 301', startTime: '10:15', endTime: '11:15', dayIndex: 4, color: Color(0xFFFF6584), icon: Icons.code_rounded),
    TimetableEntry(id: 'tt13', subject: 'Machine Learning', code: 'CS306', room: 'Room 410', startTime: '11:30', endTime: '12:30', dayIndex: 4, color: Color(0xFFFECA57), icon: Icons.psychology_rounded),
    // Saturday
    TimetableEntry(id: 'tt14', subject: 'Data Structures & Algorithms', code: 'CS301', room: 'Room 301', startTime: '09:00', endTime: '10:00', dayIndex: 5, color: Color(0xFF6C63FF), icon: Icons.account_tree_rounded),
    TimetableEntry(id: 'tt15', subject: 'Database Management', code: 'CS303', room: 'Room 402', startTime: '10:15', endTime: '11:15', dayIndex: 5, color: Color(0xFFFF9F43), icon: Icons.storage_rounded),
  ];
}

