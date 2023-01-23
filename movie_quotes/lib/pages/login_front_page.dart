import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'email_password_auth_page.dart';

class LoginFrontPage extends StatefulWidget {
  const LoginFrontPage({super.key});

  @override
  State<LoginFrontPage> createState() => _LoginFrontPageState();
}

class _LoginFrontPageState extends State<LoginFrontPage> {
  var providers = <AuthProvider<AuthListener, AuthCredential>>[
    // EmailAuthProvider(),
    GoogleProvider(
        clientId:
            "241570666356-6iov3qjio5gqetunhk1ma5ilhqbf8vd8.apps.googleusercontent.com"),
  ];

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
              title: "Log in",
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) =>
                        const EmailPasswordAuthPage(isNewUser: false)),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 30.0,
            ),
            const Text("or log in using a provider..."),
            LoginPageButton(
              title: "Google, Facebook, etc",
              callback: () {
                print("TODO: Show the Firebase auth UI");

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
                                print("Catch all auth state actions");
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              }),
                            ),
                          ],
                        )),
                  ),
                );
              },
            ),
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
      margin: const EdgeInsets.all(10.0),
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
