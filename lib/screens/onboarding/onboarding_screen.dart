import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageCtrl = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'AI Academic Mentor',
      'desc': 'Get personalized study plans, CGPA predictions, and AI-driven insights to boost your performance.',
      'icon': Icons.psychology_rounded,
      'color': AppTheme.primaryBlue,
    },
    {
      'title': 'Placement Readiness',
      'desc': 'Track your coding streaks, prepare for interviews, and monitor your placement readiness score.',
      'icon': Icons.work_rounded,
      'color': AppTheme.accentPurple,
    },
    {
      'title': 'Master Productivity',
      'desc': 'Manage assignments, track habits, and use the Pomodoro timer to stay focused.',
      'icon': Icons.timer_rounded,
      'color': AppTheme.accentGreen,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text('Skip', style: GoogleFonts.inter(color: AppTheme.textSecondaryLight, fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200, height: 200,
                          decoration: BoxDecoration(color: p['color'].withValues(alpha: 0.1), shape: BoxShape.circle),
                          child: Icon(p['icon'], color: p['color'], size: 100),
                        ),
                        const SizedBox(height: 40),
                        Text(p['title'], style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimaryLight), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        Text(p['desc'], style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondaryLight, height: 1.5), textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(_pages.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 6),
                      width: _currentIndex == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == i ? AppTheme.primaryBlue : AppTheme.borderLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentIndex == _pages.length - 1) {
                        context.go('/login');
                      } else {
                        _pageCtrl.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(60, 60),
                      padding: EdgeInsets.zero,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
