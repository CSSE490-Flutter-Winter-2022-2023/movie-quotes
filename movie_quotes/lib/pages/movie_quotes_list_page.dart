import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_quotes/components/list_page_drawer.dart';
import 'package:movie_quotes/components/movie_quote_row_component.dart';
import 'package:movie_quotes/managers/auth_manager.dart';
import 'package:movie_quotes/managers/movie_quotes_collection_manager.dart';
import 'package:movie_quotes/pages/login_front_page.dart';
import 'package:movie_quotes/pages/movie_quote_detail_page.dart';

class MovieQuotesListPage extends StatefulWidget {
  const MovieQuotesListPage({super.key});

  @override
  State<MovieQuotesListPage> createState() => _MovieQuotesListPageState();
}

class _MovieQuotesListPageState extends State<MovieQuotesListPage> {
  final quoteTextController = TextEditingController();
  final movieTextController = TextEditingController();

  StreamSubscription? movieQuotesSubscription;
  UniqueKey? _logoutSubscription;
  UniqueKey? _loginSubscription;

  @override
  void initState() {
    _loginSubscription = AuthManager.instance.addLoginObserver(
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text("Signed in as ${AuthManager.instance.email}"),
          ),
        );
        setState(() {});
      },
    );
    _logoutSubscription = AuthManager.instance.addLogoutObserver(
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text("Signed out"),
          ),
        );
        setState(() {});
      },
    );
    showAllQuotes();
    super.initState();
  }

  void showAllQuotes() {
    MovieQuotesCollectionManager.instance
        .stopListening(movieQuotesSubscription);
    movieQuotesSubscription =
        MovieQuotesCollectionManager.instance.startListening(() {
      setState(() {});
    });
  }

  void showOnlyMyQuotes() {
    MovieQuotesCollectionManager.instance
        .stopListening(movieQuotesSubscription);
    movieQuotesSubscription =
        MovieQuotesCollectionManager.instance.startListening(() {
      setState(() {});
    }, isFiltered: true);
  }

  @override
  void dispose() {
    quoteTextController.dispose();
    movieTextController.dispose();
    MovieQuotesCollectionManager.instance
        .stopListening(movieQuotesSubscription);
    AuthManager.instance.removeLoginObserver(_loginSubscription);
    AuthManager.instance.removeLogoutObserver(_logoutSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<MovieQuoteRow> movieRows =
        MovieQuotesCollectionManager.instance.latestMovieQuotes
            .map((mq) => MovieQuoteRow(
                  movieQuote: mq,
                  onTap: () async {
                    print(
                        "You clicked on the movie quote ${mq.quote} - ${mq.movie}");
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return MovieQuoteDetailPage(
                              mq.documentId!); // In Firebase use a documentId
                        },
                      ),
                    );
                    setState(() {});
                  },
                ))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Quotes"),
        actions: !AuthManager.instance.isSignedIn
            ? [
                IconButton(
                  tooltip: "Login",
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const LoginFrontPage()),
                      ),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.login),
                ),
              ]
            : null,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: movieRows,
      ),
      drawer: AuthManager.instance.isSignedIn
          ? ListPageSideDrawer((isFiltered) {
              if (isFiltered) {
                showOnlyMyQuotes();
              } else {
                showAllQuotes();
              }
            })
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (AuthManager.instance.isSignedIn) {
            showCreateQuoteDialog(context);
          } else {
            showLoginRequestDialog(context);
          }
        },
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showCreateQuoteDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a Movie Quote'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: quoteTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the quote',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: movieTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the movie',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Create'),
              onPressed: () {
                setState(() {
                  MovieQuotesCollectionManager.instance.add(
                    quote: quoteTextController.text,
                    movie: movieTextController.text,
                  );
                  quoteTextController.text = "";
                  movieTextController.text = "";
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showLoginRequestDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
            child: Text(
                "You must be signed in to post.  Would you like to sign in now?"),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Go sign in'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const LoginFrontPage()),
                  ),
                );
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}
