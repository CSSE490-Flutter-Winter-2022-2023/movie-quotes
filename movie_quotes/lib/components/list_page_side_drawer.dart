import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:movie_quotes/managers/auth_manager.dart';

class ListPageSideDrawer extends StatelessWidget {
  const ListPageSideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        // Important: Remove any padding from the ListView.
        // padding: EdgeInsets.zero,
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
              print("TODO: Call the callback saying Show only my quotes");
              // TODO: Call the callback saying Show only my quotes
              // Navigator.pop(context);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text("Show all quotes"),
            leading: const Icon(Icons.people),
            onTap: () {
              print("TODO: Call the callback saying Show all quotes");
              // TODO: Call the callback saying Show all quotes
              // Navigator.pop(context);
              Navigator.of(context).pop();
            },
          ),
          const Spacer(),
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
