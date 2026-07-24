import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/core/models/models.dart';
import 'package:student_insight_ai/providers/providers.dart';

class AIAssistantScreen extends ConsumerStatefulWidget {
  const AIAssistantScreen({super.key});
  @override
  ConsumerState<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends ConsumerState<AIAssistantScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final List<String> _quickPrompts = [
    '📊 Predict my GPA',
    '📚 Make a study plan',
    '🎯 Placement tips',
    '📝 List pending tasks',
    '💙 I\'m stressed',
    '📋 Attendance status',
  ];

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    await ref.read(aiChatProvider.notifier).sendMessage(text);
    await Future.delayed(const Duration(milliseconds: 100));
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final messages = ref.watch(aiChatProvider);
    final bg = isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue]), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('AI Mentor', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
            Row(children: [
              Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppTheme.accentGreen, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text('Online', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.accentGreen)),
            ]),
          ]),
        ]),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Clear Chat', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                content: Text('Start a new conversation?', style: GoogleFonts.inter()),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  TextButton(onPressed: () { Navigator.pop(context); }, child: const Text('Clear')),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(children: [
        // Quick Prompts
        Container(
          color: isDark ? AppTheme.surfaceDark : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _quickPrompts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () { _controller.text = _quickPrompts[i].replaceAll(RegExp(r'^[\S]+\s'), ''); _send(); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
                  ),
                  child: Text(_quickPrompts[i], style: GoogleFonts.inter(fontSize: 12, color: AppTheme.primaryBlue, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 1),

        // Messages
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (_, i) => _MessageBubble(message: messages[i], isDark: isDark),
          ),
        ),

        // Input
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -3))],
          ),
          child: SafeArea(
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: GoogleFonts.inter(color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Ask me anything about your studies...',
                    hintStyle: GoogleFonts.inter(color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight, fontSize: 14),
                    filled: true,
                    fillColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  ),
                  onSubmitted: (_) => _send(),
                  textInputAction: TextInputAction.send,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _send,
                child: Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue]), borderRadius: BorderRadius.circular(23),
                      boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))]),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;
  const _MessageBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue]), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primaryBlue : (isDark ? AppTheme.cardDark : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Text(
                message.text,
                style: GoogleFonts.inter(
                  fontSize: 14, height: 1.5,
                  color: isUser ? Colors.white : (isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(radius: 14, backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                child: const Icon(Icons.person_rounded, color: AppTheme.primaryBlue, size: 16)),
          ],
        ],
      ),
    );
  }
}
