import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_quotes/managers/auth_manager.dart';
import 'package:movie_quotes/models/movie_quote.dart';

class MovieQuotesCollectionManager {
  List<MovieQuote> latestMovieQuotes = [];
  final CollectionReference _ref;

  static final MovieQuotesCollectionManager instance =
      MovieQuotesCollectionManager._privateConstructor();

  MovieQuotesCollectionManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kMovieQuoteCollectionPath);

  StreamSubscription startListening(Function() observer,
      {bool isFilteredForMine = false}) {
    Query query = _ref.orderBy(kMovieQuote_lastTouched, descending: true);
    if (isFilteredForMine) {
      query = query.where(kMovieQuote_authorUid,
          isEqualTo: AuthManager.instance.uid);
    }
    return query.snapshots().listen((QuerySnapshot querySnapshot) {
      latestMovieQuotes =
          querySnapshot.docs.map((doc) => MovieQuote.from(doc)).toList();
      observer();
      // print(latestMovieQuotes);
    });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  Future<void> add({
    required String quote,
    required String movie,
  }) {
    return _ref
        .add({
          kMovieQuote_authorUid: AuthManager.instance.uid,
          kMovieQuote_quote: quote,
          kMovieQuote_movie: movie,
          kMovieQuote_lastTouched: Timestamp.now(),
        })
        .then((DocumentReference docRef) =>
            print("Movie Quote added with id ${docRef.id}"))
        .catchError((error) => print("Failed to add movie quote: $error"));
  }

  // Firebase UI Firestore stuff

  Query<MovieQuote> get allMovieQuotesQuery => _ref
      .orderBy(kMovieQuote_lastTouched, descending: true)
      .withConverter<MovieQuote>(
        fromFirestore: (snapshot, _) => MovieQuote.from(snapshot),
        toFirestore: (mq, _) => mq.toMap(),
      );

  Query<MovieQuote> get mineOnlyMovieQuotesQuery => allMovieQuotesQuery
      .where(kMovieQuote_authorUid, isEqualTo: AuthManager.instance.uid);
}
