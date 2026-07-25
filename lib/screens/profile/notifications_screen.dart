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

    IconData _iconFor(String type) {
      switch (type) {
        case 'assignment': return Icons.assignment_rounded;
        case 'attendance': return Icons.warning_rounded;
        case 'achievement': return Icons.emoji_events_rounded;
        case 'exam': return Icons.event_rounded;
        case 'deadline': return Icons.timer_rounded;
        case 'holiday': return Icons.celebration_rounded;
        case 'event': return Icons.local_activity_rounded;
        default: return Icons.notifications_rounded;
      }
    }

    Color _colorFor(String type) {
      switch (type) {
        case 'assignment': return AppTheme.accentAmber;
        case 'attendance': return AppTheme.accentRed;
        case 'achievement': return AppTheme.primaryBlue;
        case 'exam': return AppTheme.accentPurple;
        case 'deadline': return AppTheme.accentRed;
        case 'holiday': return AppTheme.accentGreen;
        case 'event': return AppTheme.primaryBlue;
        default: return AppTheme.accentGreen;
      }
    }

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
          color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
        ),
        backgroundColor: Colors.transparent,
        title: Text('Notifications',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(notificationsProvider.notifier).markAllRead(),
              child: Text('Mark all read', style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontSize: 12)),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.notifications_none_rounded, size: 64,
                    color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                const SizedBox(height: 16),
                Text('No notifications yet',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
                const SizedBox(height: 8),
                Text('Add events to Calendar to get reminders here',
                    style: GoogleFonts.inter(fontSize: 13,
                        color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
              ]),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (_, i) {
                final n = notifications[i];
                final color = _colorFor(n.type);
                final icon = _iconFor(n.type);

                return Dismissible(
                  key: Key(n.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => ref.read(notificationsProvider.notifier).delete(n.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.accentRed.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete_rounded, color: AppTheme.accentRed),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: AppTheme.cardDecoration(isDark: isDark).copyWith(
                      border: n.isRead
                          ? null
                          : Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
                    ),
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
                              Row(children: [
                                Expanded(child: Text(n.title,
                                    style: GoogleFonts.inter(
                                      fontWeight: n.isRead ? FontWeight.w500 : FontWeight.bold,
                                      fontSize: 14,
                                      color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
                                    ))),
                                if (!n.isRead)
                                  Container(
                                    width: 8, height: 8,
                                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                  ),
                              ]),
                              const SizedBox(height: 4),
                              Text(n.body,
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                                      height: 1.4)),
                              const SizedBox(height: 8),
                              Text(DateFormat('MMM dd, hh:mm a').format(n.time),
                                  style: GoogleFonts.inter(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
