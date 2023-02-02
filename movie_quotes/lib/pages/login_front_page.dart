import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:movie_quotes/pages/email_password_auth_page.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class LoginFrontPage extends StatefulWidget {
  const LoginFrontPage({super.key});

  @override
  State<LoginFrontPage> createState() => _LoginFrontPageState();
}

class _LoginFrontPageState extends State<LoginFrontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  "Movie Quotes",
                  style: TextStyle(
                    fontFamily: "Rowdies",
                    fontSize: 56.0,
                  ),
                ),
              ),
            ),
            LoginButton(
              title: "Log in",
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const EmailPasswordAuthPage(isNewUser: false);
                    },
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const EmailPasswordAuthPage(isNewUser: true);
                        },
                      ),
                    );
                  },
                  child: const Text("Sign Up Here"),
                ),
              ],
            ),
            const SizedBox(
              height: 60.0,
            ),
            LoginButton(
                title: "Or sign in with Google",
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => SignInScreen(
                            providers: FirebaseUIAuth.providersFor(
                              FirebaseAuth.instance.app,
                            ),
                            actions: [
                              AuthStateChangeAction(
                                ((context, state) {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                }),
                              ),
                            ],
                          )),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final String title;
  final Function() callback;
  const LoginButton({
    required this.title,
    required this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40.0,
        width: 250.0,
        margin: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: callback,
          child: Text(
            title,
            style: const TextStyle(fontSize: 16.0),
          ),
        ));
  }
}
