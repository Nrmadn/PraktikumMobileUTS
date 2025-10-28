import 'package:flutter/material.dart';
import '../constants.dart';

// =====================================================
// 📝 CUSTOM TEXT FIELD WIDGET
// =====================================================
// Widget text field yang bisa digunakan di berbagai halaman
// dengan style yang konsisten

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? Function(String?)? validator;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color backgroundColor;
  final EdgeInsets contentPadding;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.validator,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.borderColor = const Color(0xFFE0E0E0),
    this.focusedBorderColor = primaryColor,
    this.backgroundColor = cardBackgroundColor,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: paddingMedium,
      vertical: paddingNormal,
    ),
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: paddingSmall),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: textColor,
              fontSize: fontSizeMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Text Field
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          maxLines: _obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.backgroundColor,
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: textColorLighter,
              fontSize: fontSizeNormal,
            ),
            contentPadding: widget.contentPadding,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: textColorLight,
                  )
                : null,
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      widget.suffixIcon,
                      color: textColorLight,
                    ),
                    onPressed: widget.onSuffixIconPressed ?? () {},
                  )
                : (widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: textColorLight,
                        ),
                        onPressed: _toggleObscureText,
                      )
                    : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusNormal),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusNormal),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusNormal),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusNormal),
              borderSide: const BorderSide(
                color: errorColor,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusNormal),
              borderSide: const BorderSide(
                color: errorColor,
                width: 2,
              ),
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }
}

// =====================================================
// 📝 SEARCH TEXT FIELD VARIANT
// =====================================================
// Variant text field khusus untuk search

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function(String)? onChanged;
  final VoidCallback? onClear;

  const SearchTextField({
    Key? key,
    required this.controller,
    this.hint = 'Cari...',
    this.onChanged,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: cardBackgroundColor,
        hintText: hint,
        hintStyle: const TextStyle(color: textColorLighter),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: paddingMedium,
          vertical: paddingNormal,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: textColorLight,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.close,
                  color: textColorLight,
                ),
                onPressed: () {
                  controller.clear();
                  onClear?.call();
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}

// =====================================================
// 📝 TEXTAREA WIDGET
// =====================================================
// Widget untuk input text area (multiple lines)

class TextArea extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;

  const TextArea({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 5,
    this.maxLength,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: paddingSmall),
          child: Text(
            label,
            style: const TextStyle(
              color: textColor,
              fontSize: fontSizeMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          minLines: 3,
          maxLength: maxLength,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: cardBackgroundColor,
            hintText: hint,
            hintStyle: const TextStyle(color: textColorLighter),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: paddingMedium,
              vertical: paddingMedium,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusNormal),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusNormal),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusNormal),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 2,
              ),
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }
}