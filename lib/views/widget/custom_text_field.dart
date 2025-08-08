import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ⬅️ Ajouté
import 'package:pv_deme/constant/app_color.dart';

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
  final int? maxLength;
  final String? regexPattern;
  final String? validationMessage;
  final String? Function(String?)? validator;
  final bool formatAsPhoneNumber;

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
    this.maxLength,
    this.regexPattern,
    this.validationMessage,
    this.validator,
    this.formatAsPhoneNumber = false,
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
        return widget.validationMessage ?? 'Format invalide';
      }
    }

    return null;
  }

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
    final inputFormatters = <TextInputFormatter>[];

    if (widget.formatAsPhoneNumber) {
      inputFormatters.addAll([
        FilteringTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction((oldValue, newValue) {
          final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
          if (digitsOnly.length > 8) {
            return oldValue;
          }

          final formatted = _formatPhoneNumber(digitsOnly);
          return TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }),
      ]);
    }

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      readOnly: widget.isReadOnly,
      maxLines: widget.maxLines ?? 1,
      maxLength: widget.formatAsPhoneNumber ? null : widget.maxLength,
      validator: widget.validator ?? _defaultValidator,
      inputFormatters: inputFormatters,
      style: TextStyle(fontSize: 16.sp), // ✅ Texte principal
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(fontSize: 15.sp), // ✅ Label
        hintText: widget.hint,
        hintStyle: TextStyle(fontSize: 14.sp), // ✅ Hint
        prefix: widget.prefix,
        prefixIcon:
            widget.prefixIcon != null
                ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: IconTheme(
                    data: IconThemeData(size: 20.sp),
                    child: widget.prefixIcon!,
                  ),
                )
                : null,
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    size: 20.sp, // ✅ Icon taille
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : widget.suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ), // ✅ padding interne
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
