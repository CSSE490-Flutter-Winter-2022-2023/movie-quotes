import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_quotes/models/firestore_model_utils.dart';

const String kMovieQuoteCollectionPath = "MovieQuotes";
const String kMovieQuote_authorUid = "authorUid";
const String kMovieQuote_quote = "quote";
const String kMovieQuote_movie = "movie";
const String kMovieQuote_lastTouched = "lastTouched";

class MovieQuote {
  String? documentId;
  String authorUid;
  Timestamp lastTouched;
  String movie;
  String quote;

  MovieQuote({
    this.documentId,
    required this.authorUid,
    required this.lastTouched,
    required this.movie,
    required this.quote,
  });

  MovieQuote.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          quote: FirestoreModelUtils.getStringField(doc, kMovieQuote_quote),
          movie: FirestoreModelUtils.getStringField(doc, kMovieQuote_movie),
          authorUid:
              FirestoreModelUtils.getStringField(doc, kMovieQuote_authorUid),
          lastTouched: FirestoreModelUtils.getTimestampField(
              doc, kMovieQuote_lastTouched),
        );

  @override
  String toString() {
    return "$quote from the movie $movie";
  }
}
