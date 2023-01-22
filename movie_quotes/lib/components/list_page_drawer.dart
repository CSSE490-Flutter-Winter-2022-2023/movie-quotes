import 'package:flutter/material.dart';
import 'package:movie_quotes/managers/auth_manager.dart';

class ListPageSideDrawer extends StatelessWidget {
  Function(bool) callback;
  ListPageSideDrawer(this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              "Movie Quotes",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 28.0,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            title: const Text("Show only my quotes"),
            leading: const Icon(Icons.person),
            onTap: () {
              print("TODO: Show only my quotes.");
              callback(true);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Show all quotes"),
            leading: const Icon(Icons.people),
            onTap: () {
              print("TODO: Show all quotes again.");
              callback(false);
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          // const Divider(
          //   thickness: 2.0,
          // ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.of(context).pop();
              AuthManager.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
