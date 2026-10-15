import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Reusable 6-digit OTP PIN Input Component with Auto-focus Next
class OtpInputWidget extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpInputWidget({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste
      final digits = value.replaceAll(RegExp(r'\D'), '').split('');
      for (int i = 0; i < digits.length && (index + i) < widget.length; i++) {
        _controllers[index + i].text = digits[i];
      }
      _notify();
      final nextIndex = (index + digits.length).clamp(0, widget.length - 1);
      _focusNodes[nextIndex].requestFocus();
      return;
    }

    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
    _notify();
  }

  void _notify() {
    final currentOtp = _controllers.map((c) => c.text).join();
    if (widget.onChanged != null) {
      widget.onChanged!(currentOtp);
    }
    if (currentOtp.length == widget.length) {
      widget.onCompleted(currentOtp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = (constraints.maxWidth - ((widget.length - 1) * 8)) / widget.length;
        final boxSize = boxWidth.clamp(38.0, 52.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            widget.length,
            (index) => SizedBox(
              width: boxSize,
              height: boxSize * 1.15,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                autofocus: index == 0,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.secondary, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                onChanged: (val) => _onDigitChanged(index, val),
              ),
            ),
          ),
        );
      },
    );
  }
}
