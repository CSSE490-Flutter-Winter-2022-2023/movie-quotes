import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'email_password_auth_page.dart';

class LoginFrontPage extends StatefulWidget {
  const LoginFrontPage({super.key});

  @override
  State<LoginFrontPage> createState() => _LoginFrontPageState();
}

class _LoginFrontPageState extends State<LoginFrontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  "Movie Quotes",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            LoginPageButton(
              title: "Create an account",
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) =>
                        const EmailPasswordAuthPage(isNewUser: true)),
                  ),
                );
              },
            ),
            LoginPageButton(
              title: "Login",
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) =>
                        const EmailPasswordAuthPage(isNewUser: false)),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class LoginPageButton extends StatelessWidget {
  final String title;
  final Function() callback;
  const LoginPageButton({
    required this.title,
    required this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 250.0,
      margin: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: callback,
        child: Text(
          title,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
