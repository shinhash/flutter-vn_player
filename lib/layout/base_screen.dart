import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  final List<Widget> children;

  const BaseScreen({
    required this.children,
    super.key,
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2D33),
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
