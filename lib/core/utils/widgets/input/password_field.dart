import 'package:flutter/material.dart';
import 'custom_text_field.dart';

/// Reusable Password Field with Show/Hide visibility toggle
class PasswordField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData prefixIcon;

  const PasswordField({
    super.key,
    this.label = 'Password',
    this.hint = '••••••••',
    required this.controller,
    this.validator,
    this.prefixIcon = Icons.lock_outline,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      isPassword: _obscureText,
      validator: widget.validator,
      prefixIcon: widget.prefixIcon,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
