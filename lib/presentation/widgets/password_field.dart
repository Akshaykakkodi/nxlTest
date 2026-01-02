import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.passwordController,
    this.confirmController,
    this.hint,
    this.error,
  });

  /// Controller for the main password
  final TextEditingController passwordController;

  /// Optional controller for confirm password
  final TextEditingController? confirmController;

  final String? hint;
  final String? error;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Password
        TextFormField(
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: widget.hint ?? 'PASSWORD',
            labelStyle: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              letterSpacing: 2,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.black54,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),

        // Confirm Password (only if controller is provided)
        if (widget.confirmController != null) ...[
          const SizedBox(height: 24),
          TextFormField(
            controller: widget.confirmController,
            obscureText: _obscureConfirm,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'CONFIRM PASSWORD',
              labelStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                letterSpacing: 2,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black54,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirm = !_obscureConfirm;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != widget.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }
}
