import 'package:flutter/material.dart';

class CustomFormTextField extends StatefulWidget {
  const CustomFormTextField({
    super.key,
    this.hintText,
    this.icon,
    this.inverseIcon,
    this.onChanged,
  });
  final String? hintText;
  final IconData? icon;
  final IconData? inverseIcon;
  final Function(String)? onChanged;

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  bool _isPasswordSecure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      validator: (data) {
        if (data!.isEmpty) {
          return "Field is required.";
        }
        return null;
      },
      onChanged: widget.onChanged,
      // obscureText: _isPasswordSecure,
      obscureText: widget.icon != null ? _isPasswordSecure : false,
      decoration: InputDecoration(
        // suffixIcon: togglePassword(),
        suffixIcon: widget.icon != null ? togglePassword() : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isPasswordSecure = !_isPasswordSecure;
        });
      },
      icon: _isPasswordSecure ? Icon(widget.icon) : Icon(widget.inverseIcon),
      color: Colors.white,
    );
  }
}
