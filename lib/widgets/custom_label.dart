import 'package:flutter/material.dart';

class CustomLabel extends StatefulWidget {
  final String labelText;
  final String numberText;
  final bool requiredIndicator;
  final TextStyle labelStyle;
  final TextStyle requiredIndicatorStyle;


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
  State<CustomLabel> createState() => _CustomLabelState();
}

class _CustomLabelState extends State<CustomLabel> {
  var number;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.labelText,
        style: widget.labelStyle,
        children: [
          if (widget.requiredIndicator)
            TextSpan(
              text: widget.numberText,
              style: widget.requiredIndicatorStyle,
            ),
        ],
      ),
    );
  }
}
