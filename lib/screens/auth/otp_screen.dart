import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_insight_ai/providers/providers.dart';
import 'package:student_insight_ai/widgets/auth_widgets.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});
  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _ctrls = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(4, (_) => FocusNode());
  bool _loading = false;

  late AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    for (var c in _ctrls) { c.dispose(); }
    for (var n in _nodes) { n.dispose(); }
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = _ctrls.map((c) => c.text).join();
    if (otp.length < 4) {
      showAppSnackBar(context, 'Please enter the complete 4-digit OTP', isError: true);
      return;
    }

    setState(() => _loading = true);
    // Simulated API call for verifying OTP
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);

    if (otp == '1234') { // Dummy check
      showAppSnackBar(context, 'OTP Verified! Redirecting to login.');
      context.go('/login');
    } else {
      showAppSnackBar(context, 'Invalid OTP. Try 1234.', isError: true);
      for (var c in _ctrls) { c.clear(); }
      FocusScope.of(context).requestFocus(_nodes[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final bg = isDark ? const Color(0xFF0F0F1A) : const Color(0xFFF5F6FA);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: isDark ? Colors.white : Colors.black87,
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SlideTransition(
            position: _slideAnim,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  AuthHeader(
                    title: 'Verify OTP ✉️',
                    subtitle: 'We have sent a 4-digit One Time Password to\n${widget.email}',
                  ),
                  const SizedBox(height: 48),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (i) => OtpBox(
                      controller: _ctrls[i],
                      focusNode: _nodes[i],
                      nextFocus: i < 3 ? _nodes[i+1] : null,
                    )),
                  ),
                  const SizedBox(height: 48),

                  AppButton(
                    label: 'Verify & Reset Password',
                    onPressed: _loading ? null : _verifyOtp,
                    isLoading: _loading,
                    prefixWidget: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Didn't receive code? ",
                        style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 13),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                showAppSnackBar(context, 'New OTP sent!');
                              },
                              child: Text('Resend',
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF6C63FF),
                                      fontWeight: FontWeight.w700, fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
