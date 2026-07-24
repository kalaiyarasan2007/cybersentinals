import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String rollNo;
  final String department;
  final String semester;
  final String password;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNo,
    required this.department,
    required this.semester,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'rollNo': rollNo,
      'department': department,
      'semester': semester,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      rollNo: map['rollNo'],
      department: map['department'],
      semester: map['semester'],
      password: map['password'],
    );
  }
}

class LocalAuthService {
  static const String _usersKey = 'app_users';
  static const String _currentUserKey = 'current_user_id';

  Future<List<UserModel>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersStr = prefs.getString(_usersKey);
    if (usersStr == null) return [];
    
    final List<dynamic> usersJson = jsonDecode(usersStr);
    return usersJson.map((map) => UserModel.fromMap(map as Map<String, dynamic>)).toList();
  }

  Future<void> _saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users.map((u) => u.toMap()).toList();
    await prefs.setString(_usersKey, jsonEncode(usersJson));
  }

  // --- Auth Methods ---

  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String rollNo,
    required String dept,
    required String sem,
    required String password,
  }) async {
    // Artificial delay for UX
    await Future.delayed(const Duration(seconds: 1));
    
    final users = await _getUsers();
    
    // Check if email exists
    if (users.any((u) => u.email == email)) {
      throw Exception('Email already exists! Please use a different email or login.');
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      rollNo: rollNo,
      department: dept,
      semester: sem,
      password: password,
    );

    users.add(newUser);
    await _saveUsers(users);
    
    return newUser;
  }

  Future<UserModel?> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final users = await _getUsers();
    
    try {
      final user = users.firstWhere((u) => u.email == email);
      if (user.password != password) {
        throw Exception('Incorrect password. Please try again.');
      }
      
      // Save session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, user.id);
      
      return user;
    } catch (e) {
      if (e is StateError) {
        throw Exception('User not found. Please sign up first.');
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_currentUserKey);
    if (userId == null) return null;

    final users = await _getUsers();
    try {
      return users.firstWhere((u) => u.id == userId);
    } catch (e) {
      return null;
    }
  }
}
