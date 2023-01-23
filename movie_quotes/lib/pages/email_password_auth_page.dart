import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EmailPasswordAuthPage extends StatefulWidget {
  final bool isNewUser;
  const EmailPasswordAuthPage({
    required this.isNewUser,
    super.key,
  });

  @override
  State<EmailPasswordAuthPage> createState() => _EmailPasswordAuthPageState();
}

class _EmailPasswordAuthPageState extends State<EmailPasswordAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
            widget.isNewUser ? "Create a user" : "Log in an existing user"),
      ),
    );
  }
}
