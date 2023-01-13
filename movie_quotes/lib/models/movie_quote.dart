// Movie Quotes
const kMovieQuotesCollectionPath = "MovieQuotes";
const kMovieQuoteQuote = "quote";
const kMovieQuoteMovie = "movie";
const kMovieQuoteLastTouched = "lastTouched";

class MovieQuote {
  String? documentId;
  String quote;
  String movie;
  // Timestamp created;

  MovieQuote({required this.quote, required this.movie});
}
