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
      {bool isFiltered = false}) {
    Query query = _ref;
    if (isFiltered) {
      query = query.where(kMovieQuote_authorUid,
          isEqualTo: AuthManager.instance.uid);
    }
    print(
        "manager AuthManager.instance.isSignedIn = ${AuthManager.instance.isSignedIn}");
    print("manager AuthManager.instance.email = ${AuthManager.instance.email}");
    print("manager AuthManager.instance.uid = ${AuthManager.instance.uid}");
    return query
        // .where(kMovieQuote_authorUid, isEqualTo: AuthManager.instance.uid)
        .orderBy(kMovieQuote_lastTouched, descending: true)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
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

  // ------------ Firebase UI Firestore

  Query<MovieQuote> get allMovieQuotesQuery =>
      _ref.orderBy(kMovieQuote_lastTouched).withConverter<MovieQuote>(
        fromFirestore: (snapshot, options) {
          return MovieQuote.from(snapshot);
        },
        toFirestore: (mq, options) {
          return mq.toMap();
        },
      );

  Query<MovieQuote> get mineOnlyMovieQuotesQuery => allMovieQuotesQuery
      .where(kMovieQuote_authorUid, isEqualTo: AuthManager.instance.uid);
}
