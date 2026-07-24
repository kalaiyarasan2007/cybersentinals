import 'package:flutter/material.dart';

// ─── Student Model ─────────────────────────────────────────────────────────────
class StudentModel {
  final String uid, name, rollNo, department, semester, collegeName, email;
  final String? avatarInitials, photoUrl, provider, bio, phone;
  final double cgpa, predictedCgpa, attendancePercent, placementScore, productivityScore;
  final int codingStreak, assignmentsPending;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool profileCompleted;

  StudentModel({
    required this.uid,
    required this.name,
    required this.rollNo,
    required this.department,
    required this.semester,
    required this.collegeName,
    required this.email,
    this.avatarInitials,
    this.photoUrl,
    this.provider,
    this.bio,
    this.phone,
    this.cgpa = 0.0,
    this.predictedCgpa = 0.0,
    this.attendancePercent = 0.0,
    this.placementScore = 0.0,
    this.productivityScore = 0.0,
    this.codingStreak = 0,
    this.assignmentsPending = 0,
    required this.createdAt,
    this.lastLogin,
    this.profileCompleted = false,
  });

  StudentModel copyWith({
    String? name, String? rollNo, String? department, String? semester,
    String? collegeName, String? email, String? avatarInitials, String? photoUrl,
    String? bio, String? phone, double? cgpa, double? predictedCgpa,
    double? attendancePercent, double? placementScore, double? productivityScore,
    int? codingStreak, int? assignmentsPending, bool? profileCompleted, DateTime? lastLogin,
  }) => StudentModel(
    uid: uid,
    name: name ?? this.name,
    rollNo: rollNo ?? this.rollNo,
    department: department ?? this.department,
    semester: semester ?? this.semester,
    collegeName: collegeName ?? this.collegeName,
    email: email ?? this.email,
    avatarInitials: avatarInitials ?? this.avatarInitials,
    photoUrl: photoUrl ?? this.photoUrl,
    provider: provider,
    bio: bio ?? this.bio,
    phone: phone ?? this.phone,
    cgpa: cgpa ?? this.cgpa,
    predictedCgpa: predictedCgpa ?? this.predictedCgpa,
    attendancePercent: attendancePercent ?? this.attendancePercent,
    placementScore: placementScore ?? this.placementScore,
    productivityScore: productivityScore ?? this.productivityScore,
    codingStreak: codingStreak ?? this.codingStreak,
    assignmentsPending: assignmentsPending ?? this.assignmentsPending,
    createdAt: createdAt,
    lastLogin: lastLogin ?? this.lastLogin,
    profileCompleted: profileCompleted ?? this.profileCompleted,
  );

  Map<String, dynamic> toMap() => {
    'uid': uid, 'name': name, 'rollNo': rollNo, 'department': department,
    'semester': semester, 'collegeName': collegeName, 'email': email,
    'avatarInitials': avatarInitials, 'photoUrl': photoUrl, 'provider': provider,
    'bio': bio, 'phone': phone, 'cgpa': cgpa, 'predictedCgpa': predictedCgpa,
    'attendancePercent': attendancePercent, 'placementScore': placementScore,
    'productivityScore': productivityScore, 'codingStreak': codingStreak,
    'assignmentsPending': assignmentsPending,
    'createdAt': createdAt.toIso8601String(),
    'lastLogin': lastLogin?.toIso8601String(),
    'profileCompleted': profileCompleted,
  };

  factory StudentModel.fromMap(Map<String, dynamic> map) => StudentModel(
    uid: map['uid'] ?? '', name: map['name'] ?? '',
    rollNo: map['rollNo'] ?? '', department: map['department'] ?? '',
    semester: map['semester'] ?? '', collegeName: map['collegeName'] ?? '',
    email: map['email'] ?? '', avatarInitials: map['avatarInitials'],
    photoUrl: map['photoUrl'], provider: map['provider'],
    bio: map['bio'], phone: map['phone'],
    cgpa: (map['cgpa'] ?? 0.0).toDouble(),
    predictedCgpa: (map['predictedCgpa'] ?? 0.0).toDouble(),
    attendancePercent: (map['attendancePercent'] ?? 0.0).toDouble(),
    placementScore: (map['placementScore'] ?? 0.0).toDouble(),
    productivityScore: (map['productivityScore'] ?? 0.0).toDouble(),
    codingStreak: map['codingStreak'] ?? 0,
    assignmentsPending: map['assignmentsPending'] ?? 0,
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    lastLogin: map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
    profileCompleted: map['profileCompleted'] ?? false,
  );
}

// ─── Subject Model ─────────────────────────────────────────────────────────────
class SubjectModel {
  final String id, name, code;
  final double marks, maxMarks, attendancePercent;
  final int credits;
  final Color color;
  final IconData icon;

  const SubjectModel({
    required this.id, required this.name, required this.code,
    required this.marks, required this.maxMarks, required this.attendancePercent,
    this.credits = 3,
    required this.color, required this.icon,
  });

  double get percentage => (marks / maxMarks) * 100;
  int get gradePoint {
    final p = percentage;
    if (p >= 90) return 10;
    if (p >= 80) return 9;
    if (p >= 70) return 8;
    if (p >= 60) return 7;
    if (p >= 50) return 6;
    return 0;
  }

  String get grade {
    final p = percentage;
    if (p >= 90) return 'O';
    if (p >= 80) return 'A+';
    if (p >= 70) return 'A';
    if (p >= 60) return 'B+';
    if (p >= 50) return 'B';
    return 'C';
  }
  bool get isWeak => percentage < 65;

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'code': code,
    'marks': marks, 'maxMarks': maxMarks, 'attendancePercent': attendancePercent,
    'credits': credits, 'color': color.value, 'icon': icon.codePoint,
  };

  factory SubjectModel.fromMap(Map<String, dynamic> map) => SubjectModel(
    id: map['id'] ?? '', name: map['name'] ?? '', code: map['code'] ?? '',
    marks: (map['marks'] ?? 0.0).toDouble(),
    maxMarks: (map['maxMarks'] ?? 100.0).toDouble(),
    attendancePercent: (map['attendancePercent'] ?? 0.0).toDouble(),
    credits: map['credits'] ?? 3,
    color: Color(map['color'] ?? 0xFF1A73E8),
    icon: IconData(map['icon'] ?? Icons.book.codePoint, fontFamily: 'MaterialIcons'),
  );

  SubjectModel copyWith({
    double? marks, double? maxMarks, double? attendancePercent, int? credits,
  }) => SubjectModel(
    id: id, name: name, code: code,
    marks: marks ?? this.marks,
    maxMarks: maxMarks ?? this.maxMarks,
    attendancePercent: attendancePercent ?? this.attendancePercent,
    credits: credits ?? this.credits,
    color: color, icon: icon,
  );
}

// ─── Assignment Model ──────────────────────────────────────────────────────────
class AssignmentModel {
  final String id, title, subject, priority;
  final DateTime dueDate;
  bool isDone;

  AssignmentModel({
    required this.id, required this.title, required this.subject,
    required this.dueDate, required this.priority, this.isDone = false,
  });

  int get daysLeft {
    final diff = dueDate.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  AssignmentModel copyWith({bool? isDone}) => AssignmentModel(
    id: id, title: title, subject: subject, dueDate: dueDate,
    priority: priority, isDone: isDone ?? this.isDone,
  );
}

// ─── Task Model ────────────────────────────────────────────────────────────────
class TaskModel {
  final String id, title, category;
  final DateTime date;
  final TimeOfDay time;
  bool isDone;

  TaskModel({
    required this.id, required this.title, required this.category,
    required this.date, required this.time, this.isDone = false,
  });

  TaskModel copyWith({bool? isDone}) => TaskModel(
    id: id, title: title, category: category,
    date: date, time: time, isDone: isDone ?? this.isDone,
  );
}

// ─── Chat Message Model ────────────────────────────────────────────────────────
class ChatMessage {
  final String id, text;
  final bool isUser;
  final DateTime time;
  const ChatMessage({required this.id, required this.text, required this.isUser, required this.time});
}

// ─── Weekly Data Model ─────────────────────────────────────────────────────────
class WeeklyData {
  final String day;
  final double studyHours;
  final double productivityScore;
  const WeeklyData({required this.day, required this.studyHours, required this.productivityScore});
}

// ─── Semester Data Model ───────────────────────────────────────────────────────
class SemesterData {
  final String semester;
  final double cgpa;
  const SemesterData({required this.semester, required this.cgpa});
}

// ─── AI Feature Model ──────────────────────────────────────────────────────────
class AIFeature {
  final String title, subtitle, emoji;
  final Color color;
  const AIFeature({required this.title, required this.subtitle, required this.emoji, required this.color});
}

// ─── Schedule Model ────────────────────────────────────────────────────────────
class ScheduleModel {
  final String title, time, room;
  final Color color;
  final IconData icon;
  const ScheduleModel({required this.title, required this.time, required this.room, required this.color, required this.icon});
}

// ─── Exam Model ────────────────────────────────────────────────────────────────
class ExamModel {
  final String subject, date, syllabus;
  final int daysLeft;
  const ExamModel({required this.subject, required this.date, required this.syllabus, required this.daysLeft});
}

// ─── Habit Model ───────────────────────────────────────────────────────────────
class HabitModel {
  final String id, title, emoji, category;
  final int targetDays, currentStreak, bestStreak;
  final List<bool> weekProgress;
  final Color color;

  HabitModel({
    required this.id, required this.title, required this.emoji,
    required this.category, required this.targetDays,
    this.currentStreak = 0, this.bestStreak = 0,
    required this.weekProgress, required this.color,
  });

  HabitModel copyWith({List<bool>? weekProgress, int? currentStreak}) => HabitModel(
    id: id, title: title, emoji: emoji, category: category,
    targetDays: targetDays, currentStreak: currentStreak ?? this.currentStreak,
    bestStreak: bestStreak, weekProgress: weekProgress ?? this.weekProgress, color: color,
  );

  double get completionRate => weekProgress.where((d) => d).length / 7;
}

// ─── Placement Skill Model ─────────────────────────────────────────────────────
class SkillModel {
  final String id, name, category;
  final double proficiency;
  final Color color;
  const SkillModel({required this.id, required this.name, required this.category, required this.proficiency, required this.color});

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'category': category,
    'proficiency': proficiency, 'color': color.value,
  };

  factory SkillModel.fromMap(Map<String, dynamic> map) => SkillModel(
    id: map['id'] ?? '', name: map['name'] ?? '', category: map['category'] ?? '',
    proficiency: (map['proficiency'] ?? 0.0).toDouble(),
    color: Color(map['color'] ?? 0xFF1A73E8),
  );

  SkillModel copyWith({double? proficiency}) => SkillModel(
    id: id, name: name, category: category,
    proficiency: proficiency ?? this.proficiency,
    color: color,
  );
}

// ─── Notification Model ────────────────────────────────────────────────────────
class AppNotification {
  final String id, title, body, type;
  final DateTime time;
  final bool isRead;
  const AppNotification({
    required this.id, required this.title, required this.body,
    required this.type, required this.time, this.isRead = false,
  });
}

// ─── Timetable Entry Model ────────────────────────────────────────────────────
class TimetableEntry {
  final String id;
  final String subject;
  final String code;
  final String room;
  final String startTime;
  final String endTime;
  final int dayIndex; // 0=Mon, 1=Tue, 2=Wed, 3=Thu, 4=Fri, 5=Sat
  final Color color;
  final IconData icon;

  const TimetableEntry({
    required this.id,
    required this.subject,
    required this.code,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.dayIndex,
    required this.color,
    required this.icon,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'subject': subject, 'code': code, 'room': room,
    'startTime': startTime, 'endTime': endTime, 'dayIndex': dayIndex,
    'color': color.value, 'icon': icon.codePoint,
  };

  factory TimetableEntry.fromMap(Map<String, dynamic> map) => TimetableEntry(
    id: map['id'] ?? '', subject: map['subject'] ?? '', code: map['code'] ?? '',
    room: map['room'] ?? '', startTime: map['startTime'] ?? '',
    endTime: map['endTime'] ?? '', dayIndex: map['dayIndex'] ?? 0,
    color: Color(map['color'] ?? 0xFF1A73E8),
    icon: IconData(map['icon'] ?? Icons.book.codePoint, fontFamily: 'MaterialIcons'),
  );

  TimetableEntry copyWith({
    String? subject, String? code, String? room,
    String? startTime, String? endTime, int? dayIndex,
    Color? color, IconData? icon,
  }) => TimetableEntry(
    id: id,
    subject: subject ?? this.subject,
    code: code ?? this.code,
    room: room ?? this.room,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    dayIndex: dayIndex ?? this.dayIndex,
    color: color ?? this.color,
    icon: icon ?? this.icon,
  );
}

// ─── Calendar Event Model ─────────────────────────────────────────────────────
class CalendarEvent {
  final String id;
  final String title;
  final String type; // 'exam', 'event', 'deadline', 'holiday'
  final DateTime date;
  final String? description;
  final Color color;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    this.description,
    required this.color,
  });

  static Color colorForType(String type) {
    switch (type) {
      case 'exam': return const Color(0xFFFF6584);
      case 'deadline': return const Color(0xFFFF9F43);
      case 'holiday': return const Color(0xFF34A853);
      case 'event': return const Color(0xFF1A73E8);
      default: return const Color(0xFF9B59B6);
    }
  }
}

