import 'package:flutter/material.dart';
import 'package:reminder_app/utils/app_color.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final String icon;
  final TextInputType textInputType;
  final bool isObsecureText;
  final Widget? rightIcon;

  const RoundTextField(
      {super.key,
      this.textEditingController,
      this.validator,
      this.onChanged,
      required this.hintText,
      required this.icon,
      required this.textInputType,
      this.isObsecureText = false,
      this.rightIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightgrayColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: isObsecureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          prefixIcon: Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            child: Image.asset(
              icon,
              height: 20,
              width: 20,
              fit: BoxFit.contain,
              color: AppColors.grayColor,
            ),
          ),
          suffixIcon: rightIcon,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: AppColors.grayColor,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
