import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/providers/providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});
  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final student = ref.read(studentProvider);
    _nameCtrl.text = student.name;
    _bioCtrl.text = student.bio ?? '';
    _phoneCtrl.text = student.phone ?? '';
  }

  void _save() {
    ref.read(studentProvider.notifier).updateField(
      name: _nameCtrl.text,
      bio: _bioCtrl.text,
      phone: _phoneCtrl.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
    context.pop();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ref.read(profilePhotoProvider.notifier).setPhoto(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final photoPath = ref.watch(profilePhotoProvider);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => context.pop(), color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
        backgroundColor: Colors.transparent,
        title: Text('Edit Profile', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
        actions: [
          TextButton(onPressed: _save, child: Text('Save', style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 16))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    backgroundImage: photoPath != null ? FileImage(File(photoPath)) : null,
                    child: photoPath == null
                        ? Text(ref.read(studentProvider).avatarInitials ?? 'S',
                            style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontSize: 36, fontWeight: FontWeight.bold))
                        : null,
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppTheme.primaryBlue, shape: BoxShape.circle, border: Border.all(color: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight, width: 3)),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameCtrl,
            style: GoogleFonts.inter(color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
            decoration: const InputDecoration(labelText: 'Full Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bioCtrl,
            style: GoogleFonts.inter(color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
            decoration: const InputDecoration(labelText: 'Bio (Short description)'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            style: GoogleFonts.inter(color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
            decoration: const InputDecoration(labelText: 'Phone Number'),
          ),
        ]),
      ),
    );
  }
}
