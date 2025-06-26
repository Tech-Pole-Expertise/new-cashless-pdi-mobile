import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final bool isPassword;
  final bool isReadOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String? regexPattern;
  final String? validationMessage;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.isPassword = false,
    this.isReadOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.maxLength,
    this.regexPattern,
    this.validationMessage,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }

    if (widget.regexPattern != null) {
      final regex = RegExp(widget.regexPattern!);
      if (!regex.hasMatch(value)) {
        return widget.validationMessage ?? 'Format invalide';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      readOnly: widget.isReadOnly,
      maxLines: widget.maxLines ?? 1,
      maxLength: widget.maxLength ?? 100,
      validator: widget.validator ?? _defaultValidator,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
