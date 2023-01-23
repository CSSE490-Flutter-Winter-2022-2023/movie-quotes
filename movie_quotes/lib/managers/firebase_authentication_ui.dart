import 'package:flutter/material.dart';

// SignInScreen(
//   actions: [
//     AuthStateChangeAction<SignedIn>((context, state) {
//       if (!state.user!.emailVerified) {
//         Navigator.pushNamed(context, '/verify-email');
//       } else {
//         Navigator.pushReplacementNamed(context, '/profile');
//       }
//     }),
//   ],
// );

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     const providers = [EmailAuthProvider()];

//     return MaterialApp(
//       initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/profile',
//       routes: {
//         '/sign-in': (context) => SignInScreen(providers: providers),
//         '/profile': (context) => ProfileScreen(providers: providers),
//       },
//     );
//   }
// }