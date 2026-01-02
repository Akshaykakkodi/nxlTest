import 'package:flutter/material.dart';

class CustomFieldWidget extends StatelessWidget {
  const CustomFieldWidget({
    super.key,
    required TextEditingController emailController,
    required this.hint,
    this.suffixIcon,
    this.isEmail,
  }) : _emailController = emailController;

  final TextEditingController _emailController;
  final String hint;
  final Widget? suffixIcon;
  final bool? isEmail;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.black),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(
          color: Colors.black54,
          fontSize: 12,
          letterSpacing: 2,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        suffix: suffixIcon,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hint';
        }

        if (!value.contains('@') && isEmail == true) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}
