import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => context.pop(), color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
        backgroundColor: Colors.transparent,
        title: Text('Settings', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection('App Settings', [
            SwitchListTile(
              title: Text('Dark Mode', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
              subtitle: Text('Switch between light and dark themes', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
              value: isDark,
              onChanged: (v) => ref.read(themeProvider.notifier).toggle(),
              activeThumbColor: AppTheme.primaryBlue,
            ),
            ListTile(
              title: Text('Language', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
              subtitle: Text('English', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {},
            ),
          ], isDark),
          const SizedBox(height: 24),
          _buildSection('Notifications', [
            SwitchListTile(
              title: Text('Push Notifications', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
              value: true,
              onChanged: (v) {},
              activeThumbColor: AppTheme.primaryBlue,
            ),
            SwitchListTile(
              title: Text('Email Alerts', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
              value: false,
              onChanged: (v) {},
              activeThumbColor: AppTheme.primaryBlue,
            ),
          ], isDark),
          const SizedBox(height: 24),
          _buildSection('About', [
            ListTile(
              title: Text('Privacy Policy', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {},
            ),
            ListTile(
              title: Text('Terms of Service', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {},
            ),
            ListTile(
              title: Text('App Version', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
              subtitle: Text('v2.0.0 (Build 1)', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
            ),
          ], isDark),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
        ),
        Container(
          decoration: AppTheme.cardDecoration(isDark: isDark),
          child: Column(children: children.asMap().entries.map((e) {
            return Column(children: [
              e.value,
              if (e.key < children.length - 1) Divider(height: 1, color: isDark ? AppTheme.borderDark : AppTheme.borderLight),
            ]);
          }).toList()),
        ),
      ],
    );
  }
}
