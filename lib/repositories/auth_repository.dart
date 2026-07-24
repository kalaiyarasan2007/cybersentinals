import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_insight_ai/core/models/models.dart';

class AuthRepository {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';

  // ─── Sign Up ─────────────────────────────────────────────────────────────────
  Future<StudentModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String department,
    required String semester,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    
    // In a real app, this would call Firebase Auth.
    // For local mockup, we create a student model and save it.
    final student = StudentModel(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      rollNo: 'NEW_${DateTime.now().millisecond}',
      department: department,
      semester: semester,
      collegeName: 'Your College',
      email: email,
      avatarInitials: name.isNotEmpty ? name[0].toUpperCase() : 'S',
      provider: 'email',
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );

    await _saveUserLocal(student);
    return student;
  }

  // ─── Login ───────────────────────────────────────────────────────────────────
  Future<StudentModel> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    
    // Check if user exists locally (mock check)
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    
    if (data != null) {
      final student = StudentModel.fromMap(jsonDecode(data));
      if (student.email == email) {
        return student.copyWith(lastLogin: DateTime.now());
      }
    }
    
    // If not found in local, simulate a success for demo purposes if email is valid
    if (email.contains('@')) {
       final student = StudentModel(
        uid: 'demo_user',
        name: email.split('@')[0],
        rollNo: 'DEMO123',
        department: 'Computer Science',
        semester: '6th Semester',
        collegeName: 'Demo College',
        email: email,
        avatarInitials: email[0].toUpperCase(),
        provider: 'email',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
      await _saveUserLocal(student);
      return student;
    }
    
    throw Exception('Invalid email or password');
  }

  // ─── Get Current User ───────────────────────────────────────────────────────
  Future<StudentModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data != null) {
      return StudentModel.fromMap(jsonDecode(data));
    }
    return null;
  }

  // ─── Sign Out ───────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  // ─── Private Helpers ────────────────────────────────────────────────────────
  Future<void> _saveUserLocal(StudentModel student) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(student.toMap()));
    await prefs.setString(_tokenKey, 'mock_token_${student.uid}');
  }
}
