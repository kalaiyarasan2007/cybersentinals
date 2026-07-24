import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/providers/providers.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => context.pop(), color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
        backgroundColor: Colors.transparent,
        title: Text('Notifications', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
      ),
      body: notifications.isEmpty
          ? Center(child: Text('No new notifications', style: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (_, i) {
                final n = notifications[i];
                Color color;
                IconData icon;
                switch (n.type) {
                  case 'assignment': color = AppTheme.accentAmber; icon = Icons.assignment_rounded; break;
                  case 'attendance': color = AppTheme.accentRed; icon = Icons.warning_rounded; break;
                  case 'achievement': color = AppTheme.primaryBlue; icon = Icons.emoji_events_rounded; break;
                  case 'exam': color = AppTheme.accentPurple; icon = Icons.event_rounded; break;
                  default: color = AppTheme.accentGreen; icon = Icons.notifications_rounded;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.cardDecoration(isDark: isDark),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
                            const SizedBox(height: 4),
                            Text(n.body, style: GoogleFonts.inter(fontSize: 13, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight, height: 1.4)),
                            const SizedBox(height: 8),
                            Text(DateFormat('MMM dd, hh:mm a').format(n.time), style: GoogleFonts.inter(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
