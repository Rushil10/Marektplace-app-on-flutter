import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocy/components/text_field_container.dart';
import 'package:grocy/constants.dart';

class RoundedInputNumberField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputNumberField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
