import 'package:flutter/material.dart';
import 'package:movie_quotes/models/movie_quote.dart';

class MovieQuoteRow extends StatelessWidget {
  final MovieQuote mq;
  const MovieQuoteRow(
    this.mq, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.movie_creation_outlined),
          trailing: const Icon(Icons.chevron_right),
          title: Text(
            mq.quote,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            mq.movie,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
