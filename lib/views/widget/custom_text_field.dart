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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      readOnly: widget.isReadOnly,
      maxLines: widget.maxLines ?? 1,
      maxLength: widget.maxLength ?? 100,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
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
