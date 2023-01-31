import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_quotes/models/firestore_model_utils.dart';

const String kMovieQuoteCollectionPath = "MovieQuotes";
const String kMovieQuote_authorUid = "authorUid";
const String kMovieQuote_lastTouched = "lastTouched";
const String kMovieQuote_movie = "movie";
const String kMovieQuote_quote = "quote";

class MovieQuote {
  String? documentId;
  String authorUid;
  Timestamp lastTouched;
  String movie;
  String quote;

  MovieQuote({
    this.documentId,
    required this.authorUid,
    required this.quote,
    required this.movie,
    required this.lastTouched,
  });

  MovieQuote.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          authorUid:
              FirestoreModelUtils.getStringField(doc, kMovieQuote_authorUid),
          lastTouched: FirestoreModelUtils.getTimestampField(
              doc, kMovieQuote_lastTouched),
          movie: FirestoreModelUtils.getStringField(doc, kMovieQuote_movie),
          quote: FirestoreModelUtils.getStringField(doc, kMovieQuote_quote),
        );

  @override
  String toString() {
    return "$quote from the movie $movie";
  }
}
