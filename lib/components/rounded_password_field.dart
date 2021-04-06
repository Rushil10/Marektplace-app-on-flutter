import 'package:flutter/material.dart';
import 'package:grocy/components/text_field_container.dart';
import 'package:grocy/constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);
  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  //final ValueChanged<String> onChanged;
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText=!_obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: _obscureText,
        onChanged: widget.onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.visibility),
            color: kPrimaryColor,
            onPressed: _toggle,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}



