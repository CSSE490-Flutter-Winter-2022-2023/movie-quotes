import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:movie_quotes/managers/auth_manager.dart';
import 'package:movie_quotes/pages/movie_quotes_list_page.dart';

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
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  // https://docs.flutter.dev/cookbook/forms/validation
  final _formKey = GlobalKey<FormState>();
  UniqueKey? _loginSubscription;

  @override
  void initState() {
    emailTextController.text = "a@b.co"; // Temp HACK!
    passwordTextController.text = "123456"; // Temp HACK!

    _loginSubscription = AuthManager.instance.addLoginObserver(() {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
    super.initState();
  }

  @override
  void dispose() {
    AuthManager.instance.removeLoginObserver(_loginSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            widget.isNewUser ? "Create a New User" : "Log in an Existing User"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 150.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: emailTextController,
                validator: (value) {
                  if (value == null || !EmailValidator.validate(value)) {
                    return 'Not a valid email address';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(20.0),
                        ),
                    labelText: 'Email',
                    hintText: 'Enter valid email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextFormField(
                controller: passwordTextController,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Passwords must be 6 characters or more';
                  }
                  return null;
                },
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(20.0),
                        ),
                    labelText: 'Password',
                    hintText: 'Passwords must be 6 characters or more'),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Everything is valid!");
                    if (widget.isNewUser) {
                      print("Create a new user");
                      AuthManager.instance.createUserWithEmailAndPassword(
                        context: context,
                        email: emailTextController.text,
                        password: passwordTextController.text,
                      );
                    } else {
                      print("Log in existing user");
                      AuthManager.instance.signInWithEmailAndPassword(
                        context: context,
                        email: emailTextController.text,
                        password: passwordTextController.text,
                      );
                    }
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   duration: const Duration(seconds: 2),
                    //   content: Text(
                    //       widget.isNewUser ? "Creating account" : "Logging in"),
                    // ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Invalid email or password.")),
                    );
                  }
                },
                child: Text(
                  widget.isNewUser ? "Create account" : "Log in",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
