import 'package:flutter/material.dart';
import 'dart:async';

class TypewriterHintText extends StatefulWidget {
  final List<String> searchQueries;
  final String hintTextPrefix;
  final Duration typeSpeed;
  final Duration backspaceSpeed;
  final Duration delay;

  TypewriterHintText({
    required this.searchQueries,
    required this.hintTextPrefix,
    this.typeSpeed = const Duration(milliseconds: 150),
    this.backspaceSpeed = const Duration(milliseconds: 100),
    this.delay = const Duration(seconds: 1),
  });

  @override
  _TypewriterHintTextState createState() => _TypewriterHintTextState();
}

class _TypewriterHintTextState extends State<TypewriterHintText> {
  TextEditingController _controller = TextEditingController();
  int _queryIndex = 0;
  String _currentQuery = '';
  Timer? _timer;
  bool _isTyping = true;

  @override
  void initState() {
    super.initState();
    _startTypewriterEffect();
  }

  void _startTypewriterEffect() {
    _timer = Timer.periodic(
      _isTyping ? widget.typeSpeed : widget.backspaceSpeed,
          (timer) {
        setState(() {
          if (_isTyping) {
            if (_currentQuery.length < widget.searchQueries[_queryIndex].length) {
              _currentQuery += widget.searchQueries[_queryIndex][_currentQuery.length];
            } else {
              _isTyping = false;
              _pauseAndRestart(widget.delay);
            }
          } else {
            if (_currentQuery.isNotEmpty) {
              _currentQuery = _currentQuery.substring(0, _currentQuery.length - 1);
            } else {
              _isTyping = true;
              _queryIndex = (_queryIndex + 1) % widget.searchQueries.length;
              _pauseAndRestart(widget.delay);
            }
          }
        });
      },
    );
  }

  void _pauseAndRestart(Duration delay) {
    _timer?.cancel();
    Future.delayed(delay, () {
      if (mounted) {
        _controller.clear(); // Clear text field when restarting typing effect
        _startTypewriterEffect();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: '${widget.hintTextPrefix} $_currentQuery',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      readOnly: true, // Make the text field read-only to prevent user input
    );
  }
}
