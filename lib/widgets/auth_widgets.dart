import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Reusable AppTextField ─────────────────────────────────────────────────────
class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int maxLines;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;

  const AppTextField({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.controller,
    this.hint,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? const Color(0xFF252538) : const Color(0xFFF5F6FA);
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;

    return Focus(
      onFocusChange: (f) => setState(() => _isFocused = f),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && _obscure,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onChanged: widget.onChanged,
        enabled: widget.enabled,
        maxLines: widget.isPassword ? 1 : widget.maxLines,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          labelStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: _isFocused ? const Color(0xFF6C63FF) : Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
          hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
          prefixIcon: Icon(
            widget.prefixIcon,
            color: _isFocused ? const Color(0xFF6C63FF) : Colors.grey[400],
            size: 20,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                )
              : (widget.suffixIcon != null
                  ? Icon(widget.suffixIcon, color: Colors.grey[400], size: 20)
                  : null),
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF6584), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF6584), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFFFF6584)),
        ),
      ),
    );
  }
}

// ── Reusable AppButton ────────────────────────────────────────────────────────
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Widget? prefixWidget;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.prefixWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 56,
    this.borderRadius = 14,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween<double>(begin: 1, end: 0.96).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    if (widget.isOutlined) {
      return ScaleTransition(
        scale: _scaleAnim,
        child: GestureDetector(
          onTapDown: (_) { if (isEnabled) _ctrl.forward(); },
          onTapUp: (_) { _ctrl.reverse(); if (isEnabled) widget.onPressed!(); },
          onTapCancel: () => _ctrl.reverse(),
          child: SizedBox(
            width: double.infinity,
            height: widget.height,
            child: OutlinedButton(
              onPressed: isEnabled ? widget.onPressed : null,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: widget.backgroundColor ?? const Color(0xFF6C63FF),
                  width: 1.5,
                ),
                foregroundColor: widget.foregroundColor ?? const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius)),
              ),
              child: _buildChild(),
            ),
          ),
        ),
      );
    }

    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: (_) { if (isEnabled) _ctrl.forward(); },
        onTapUp: (_) { _ctrl.reverse(); },
        onTapCancel: () => _ctrl.reverse(),
        child: SizedBox(
          width: double.infinity,
          height: widget.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: isEnabled
                  ? const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF4A47A3)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: isEnabled ? null : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: isEnabled
                  ? [BoxShadow(
                      color: const Color(0xFF6C63FF).withAlpha(60),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )]
                  : null,
            ),
            child: ElevatedButton(
              onPressed: isEnabled ? widget.onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius)),
              ),
              child: _buildChild(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChild() {
    if (widget.isLoading) {
      return const SizedBox(
        width: 22, height: 22,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
      );
    }
    if (widget.prefixWidget != null) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        widget.prefixWidget!,
        const SizedBox(width: 10),
        Text(widget.label, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15)),
      ]);
    }
    return Text(widget.label,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15));
  }
}

// ── Social Login Button ───────────────────────────────────────────────────────
class SocialLoginButton extends StatelessWidget {
  final String label;
  final String logoLetter;
  final Color logoColor;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.logoLetter,
    required this.logoColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppButton(
      label: label,
      isOutlined: true,
      onPressed: onPressed,
      backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
      foregroundColor: isDark ? Colors.white : Colors.black87,
      prefixWidget: Container(
        width: 24, height: 24,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Center(
          child: Text(logoLetter,
              style: TextStyle(
                  color: logoColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 13)),
        ),
      ),
    );
  }
}

// ── Auth Header ───────────────────────────────────────────────────────────────
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 26, fontWeight: FontWeight.w800,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF2D3436))),
        const SizedBox(height: 6),
        Text(subtitle,
            style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
                height: 1.4)),
      ],
    );
  }
}

// ── Divider with text ─────────────────────────────────────────────────────────
class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text(text,
            style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 12,
                fontWeight: FontWeight.w500)),
      ),
      Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
    ]);
  }
}

// ── Auth Logo ─────────────────────────────────────────────────────────────────
class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF4A47A3)]),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.psychology_alt, color: Colors.white, size: 26),
      ),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('StudentInsight',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800, fontSize: 17,
                color: const Color(0xFF6C63FF))),
        Text('AI Academic Mentor',
            style: GoogleFonts.poppins(
                fontSize: 10, color: Colors.grey[500],
                fontWeight: FontWeight.w500, letterSpacing: 0.5)),
      ]),
    ]);
  }
}

// ── OTP Input Box ─────────────────────────────────────────────────────────────
class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  const OtpBox({super.key, required this.controller, required this.focusNode, this.nextFocus});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: 52, height: 60,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: isDark ? const Color(0xFF252538) : const Color(0xFFF5F6FA),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2)),
        ),
        onChanged: (val) {
          if (val.isNotEmpty && nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
      ),
    );
  }
}

// ── SnackBar Helper ───────────────────────────────────────────────────────────
void showAppSnackBar(BuildContext context, String msg, {bool isError = false}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(children: [
      Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
          color: Colors.white, size: 18),
      const SizedBox(width: 10),
      Expanded(child: Text(msg, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white))),
    ]),
    backgroundColor: isError ? const Color(0xFFFF6584) : const Color(0xFF43B97F),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 3),
  ));
}
