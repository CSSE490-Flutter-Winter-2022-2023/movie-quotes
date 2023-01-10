import 'package:flutter/material.dart';
import 'package:movie_quotes/components/movie_quote_row_component.dart';
import 'package:movie_quotes/models/movie_quote.dart';

class MovieQuotesListPage extends StatefulWidget {
  const MovieQuotesListPage({super.key});

  @override
  State<MovieQuotesListPage> createState() => _MovieQuotesListPageState();
}

class _MovieQuotesListPageState extends State<MovieQuotesListPage> {
  final quotes = <MovieQuote>[]; // Later we will remove this and use Firestore

  @override
  void initState() {
    super.initState();
    quotes.add(
      MovieQuote(
        quote: "I'll be back",
        movie: "The Terminator",
      ),
    );
    // quotes.add(
    //   MovieQuote(
    //     quote: "Everything is Awesome",
    //     movie: "The Lego Movie",
    //   ),
    // );
    quotes.add(
      MovieQuote(
        quote:
            "Hello. My name is Inigo Montoya. You killed my father. Prepare to die.",
        movie: "The Princess Bride",
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final List<MovieQuoteRow> movieRows = [];
    // for (final movieQuote in quotes) {
    //   movieRows.add(MovieQuoteRow(movieQuote));
    // }

    final List<MovieQuoteRow> movieRows =
        quotes.map((mq) => MovieQuoteRow(mq)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Quotes"),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        // children: [
        //   MovieQuoteRow(quotes[0]),
        //   MovieQuoteRow(quotes[1]),
        //   MovieQuoteRow(quotes[2]),
        // ],
        children: movieRows,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("You pressed the fab!");
        },
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }
}
