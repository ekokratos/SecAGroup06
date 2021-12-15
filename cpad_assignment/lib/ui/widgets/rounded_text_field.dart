import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedTextField extends StatelessWidget {
  final String? hintText;
  final String? prefixText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isReadOnly;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Function? onTap;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  RoundedTextField({
    Key? key,
    this.hintText,
    this.prefixText,
    this.keyboardType,
    this.inputFormatters,
    this.controller,
    this.validator,
    this.onTap,
    this.isReadOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.5,
      shadowColor: Colors.grey.shade50,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      child: TextFormField(
        textCapitalization: keyboardType == TextInputType.emailAddress
            ? TextCapitalization.none
            : TextCapitalization.sentences,
        validator: validator,
        controller: controller,
        readOnly: isReadOnly,
        obscureText: obscureText,
        maxLines: maxLines,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: kMediumText,
          letterSpacing: 0.6,
          color: kPrimaryColor,
          fontWeight: kBold,
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          // suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 5,
              vertical: SizeConfig.blockSizeHorizontal * 3.6),
          hintText: hintText ?? '',
          prefixText: prefixText,
          prefixStyle: TextStyle(fontSize: kMediumText, fontFamily: ''),
          isDense: false,
          hintStyle: TextStyle(fontSize: kMediumText, color: kPrimaryColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(30),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
