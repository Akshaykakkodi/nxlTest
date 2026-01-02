import 'package:flutter/material.dart';
import 'package:test/presentation/widgets/validators/input_validator_mixin.dart';

enum FieldType { email, password, text, number }

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final FieldType fieldType;
  final String? fieldName;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.fieldType = FieldType.text,
    this.fieldName,
    this.onChanged,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with InputValidatorMixin {
  late final TextEditingController _controller;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _isPasswordVisible = !widget.obscureText;
  }

  @override
  void dispose() {
    // Only dispose the controller if it was created in this widget
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  String? _validate(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }

    switch (widget.fieldType) {
      case FieldType.email:
        return validateEmail(value);
      case FieldType.password:
        return validatePassword(value);
      case FieldType.text:
      case FieldType.number:
        if (widget.fieldName != null) {
          return validateRequired(value, widget.fieldName!);
        }
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: _controller,
      keyboardType: _getKeyboardType(),
      obscureText: widget.obscureText && !_isPasswordVisible,
      validator: _validate,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      textCapitalization: widget.textCapitalization,
      style: const TextStyle(fontSize: 14, letterSpacing: 1),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
          fontSize: 12,
          letterSpacing: 1,
        ),
        hintText: widget.hint,
        hintStyle: const TextStyle(
          fontSize: 12,
          letterSpacing: 1,
          color: Colors.black54,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.black, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        suffixIcon: _buildSuffixIcon(),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }

    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _isPasswordVisible
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Colors.black54,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    }

    return null;
  }

  TextInputType _getKeyboardType() {
    if (widget.keyboardType != null) {
      return widget.keyboardType!;
    }

    switch (widget.fieldType) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.number:
        return TextInputType.number;
      case FieldType.password:
      case FieldType.text:
        return TextInputType.text;
    }
  }
}
