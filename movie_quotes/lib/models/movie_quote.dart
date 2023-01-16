// Movie Quotes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_quotes/models/firestore_model_utils.dart';

const kMovieQuotesCollectionPath = "MovieQuotes";
const kMovieQuoteQuote = "quote";
const kMovieQuoteMovie = "movie";
const kMovieQuoteLastTouched = "lastTouched";

class MovieQuote {
  String? documentId;
  String quote;
  String movie;
  Timestamp lastTouched;

  MovieQuote({
    this.documentId,
    required this.quote,
    required this.movie,
    required this.lastTouched,
  });

  MovieQuote.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          quote: FirestoreModelUtils.getStringField(doc, kMovieQuoteQuote),
          movie: FirestoreModelUtils.getStringField(doc, kMovieQuoteMovie),
          lastTouched: FirestoreModelUtils.getTimestampField(
              doc, kMovieQuoteLastTouched),
        );

  Map<String, Object?> toMap() {
    return {
      kMovieQuoteQuote: quote,
      kMovieQuoteMovie: movie,
      kMovieQuoteLastTouched: lastTouched,
    };
  }

  @override
  String toString() {
    return "TestToString $quote from $movie";
  }
}
