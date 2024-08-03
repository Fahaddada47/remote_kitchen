import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final String labelText;
  final String numberText;
  final bool requiredIndicator;
  final TextStyle labelStyle;
  final TextStyle requiredIndicatorStyle;

  var number;

   CustomLabel({
    Key? key,
    required this.labelText,
    required this.numberText,
    this.requiredIndicator = false,
    this.labelStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.requiredIndicatorStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: labelStyle,
        children: [
          if (requiredIndicator)
            TextSpan(
              text: numberText,
              style: requiredIndicatorStyle,
            ),
        ],
      ),
    );
  }
}
