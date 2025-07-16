import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdi_deme/constant/app_color.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final bool isPassword;
  final bool isReadOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int? maxLines;
  final String? regexPattern;
  final String? validationMessage;
  final String? Function(String?)? validator;
  final bool formatAsPhoneNumber; // Nouveau

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.isPassword = false,
    this.isReadOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.prefix,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.regexPattern,
    this.validationMessage,
    this.validator,
    this.formatAsPhoneNumber = false, // Nouveau
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
      if (!regex.hasMatch(value.replaceAll(' ', ''))) {
        // enlever les espaces pour valider
        return widget.validationMessage ?? 'Format invalide';
      }
    }

    return null;
  }

  // Formatage du numéro : 76789034 → 76 78 90 34
  String _formatPhoneNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i != 0 && i % 2 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      readOnly: widget.isReadOnly,
      maxLines: widget.maxLines ?? 1,
      validator: widget.validator ?? _defaultValidator,
      inputFormatters:
          widget.formatAsPhoneNumber
              ? [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final formatted = _formatPhoneNumber(newValue.text);
                  return TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(
                      offset: formatted.length,
                    ),
                  );
                }),
              ]
              : [],
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefix: widget.prefix,
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    // color: AppColors.textPrimary,
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
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
