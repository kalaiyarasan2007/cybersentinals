import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/core/data/sample_data.dart';
import 'package:student_insight_ai/providers/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final student = ref.watch(studentProvider);
    final photoPath = ref.watch(profilePhotoProvider);
    final bg = isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppTheme.primaryBlue,
            actions: [
              IconButton(icon: const Icon(Icons.settings_rounded, color: Colors.white), onPressed: () => context.push('/settings')),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [AppTheme.primaryBlue, Color(0xFF4285F4)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: photoPath != null ? FileImage(File(photoPath)) : null,
                      child: photoPath == null
                          ? Text(student.avatarInitials ?? 'S', style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontSize: 30, fontWeight: FontWeight.bold))
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(student.name, style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(student.email, style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                  ]),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Stats Row
                Row(children: [
                  _ProfileStat(title: 'CGPA', value: student.cgpa.toStringAsFixed(1), isDark: isDark),
                  _ProfileStat(title: 'Attendance', value: '${student.attendancePercent.toInt()}%', isDark: isDark),
                  _ProfileStat(title: 'Streak', value: '${student.codingStreak}d', isDark: isDark),
                  _ProfileStat(title: 'Placement', value: '${student.placementScore.toInt()}%', isDark: isDark),
                ]),
                const SizedBox(height: 20),

                // Bio Card
                if (student.bio != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: AppTheme.cardDecoration(isDark: isDark),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('About Me', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
                      const SizedBox(height: 6),
                      Text(student.bio!, style: GoogleFonts.inter(fontSize: 13, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight, height: 1.5)),
                    ]),
                  ),
                const SizedBox(height: 20),

                // Skills
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Skills', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
                    TextButton(onPressed: () => context.push('/placement'), child: const Text('Manage')),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.cardDecoration(isDark: isDark),
                  child: Column(children: ref.watch(skillsProvider).take(5).map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(children: [
                      SizedBox(width: 120, child: Text(s.name, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight))),
                      Expanded(child: LinearPercentIndicator(
                        lineHeight: 8,
                        percent: s.proficiency,
                        progressColor: s.color,
                        backgroundColor: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                        barRadius: const Radius.circular(4),
                        animation: true,
                        padding: EdgeInsets.zero,
                      )),
                      const SizedBox(width: 8),
                      Text('${(s.proficiency * 100).toInt()}%', style: GoogleFonts.inter(fontSize: 11, color: s.color, fontWeight: FontWeight.bold)),
                    ]),
                  )).toList()),
                ),
                const SizedBox(height: 20),

                // Menu Items
                Text('Account', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
                const SizedBox(height: 12),
                _MenuSection(isDark: isDark, items: [
                  _MenuItem(icon: Icons.person_outline, title: 'Edit Profile', subtitle: 'Update your information', onTap: () => context.push('/edit-profile'), isDark: isDark),
                  _MenuItem(icon: Icons.work_outline_rounded, title: 'Placement Module', subtitle: 'Track your placement readiness', onTap: () => context.push('/placement'), isDark: isDark),
                  _MenuItem(icon: Icons.notifications_outlined, title: 'Notifications', subtitle: '${SampleData.notifications.length} new alerts', onTap: () => context.push('/notifications'), isDark: isDark),
                ]),
                const SizedBox(height: 16),
                Text('Preferences', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
                const SizedBox(height: 12),
                _MenuSection(isDark: isDark, items: [
                  _MenuItem(icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, title: isDark ? 'Light Mode' : 'Dark Mode', subtitle: 'Toggle app theme', onTap: () => ref.read(themeProvider.notifier).toggle(), isDark: isDark),
                  _MenuItem(icon: Icons.settings_outlined, title: 'Settings', subtitle: 'App preferences', onTap: () => context.push('/settings'), isDark: isDark),
                ]),
                const SizedBox(height: 16),

                // Logout
                GestureDetector(
                  onTap: () => _showLogoutDialog(context, ref),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.accentRed.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accentRed.withValues(alpha: 0.3)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.logout_rounded, color: AppTheme.accentRed),
                      const SizedBox(width: 14),
                      Text('Logout', style: GoogleFonts.inter(color: AppTheme.accentRed, fontWeight: FontWeight.bold, fontSize: 15)),
                    ]),
                  ),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Logout', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to logout?', style: GoogleFonts.inter()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: GoogleFonts.inter())),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentRed, foregroundColor: Colors.white, minimumSize: const Size(80, 40)),
            onPressed: () async {
              Navigator.pop(context);
              final authRepo = ref.read(authRepositoryProvider);
              await authRepo.signOut();
              ref.read(currentUserProvider.notifier).state = null;
              if (context.mounted) context.go('/login');
            },
            child: Text('Logout', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String title, value;
  final bool isDark;
  const _ProfileStat({required this.title, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: AppTheme.cardDecoration(isDark: isDark),
      child: Column(children: [
        Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.primaryBlue)),
        const SizedBox(height: 2),
        Text(title, style: GoogleFonts.inter(fontSize: 9, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight), textAlign: TextAlign.center),
      ]),
    ));
  }
}

class _MenuSection extends StatelessWidget {
  final List<Widget> items;
  final bool isDark;
  const _MenuSection({required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration(isDark: isDark),
      child: Column(children: items.asMap().entries.map((e) {
        return Column(children: [
          e.value,
          if (e.key < items.length - 1) Divider(height: 1, color: isDark ? AppTheme.borderDark : AppTheme.borderLight, indent: 56),
        ]);
      }).toList()),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  final bool isDark;
  const _MenuItem({required this.icon, required this.title, required this.subtitle, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: AppTheme.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
      ),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
      onTap: onTap,
    );
  }
}
