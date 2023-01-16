import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_quotes/models/movie_quote.dart';

class MovieQuotesCollectionManager {
  // List<QueryDocumentSnapshot<MovieQuote>> lastestMovieQuotes = [];
  List<MovieQuote> lastestMovieQuotes = [];
  final CollectionReference _ref;

  MovieQuotesCollectionManager._privateConstructor()
      : _ref =
            FirebaseFirestore.instance.collection(kMovieQuotesCollectionPath);

  static final MovieQuotesCollectionManager instance =
      MovieQuotesCollectionManager._privateConstructor();

  Future<void> add(MovieQuote mq) async {
    return _ref
        .add(mq.toMap())
        .then((value) => print("added movie quote"))
        .catchError((error) {
      print("Failed to add movie quote: $error");
      return;
    });
  }

  StreamSubscription startListening(Function observer) {
    return _ref
        .orderBy(kMovieQuoteLastTouched, descending: true)
        // .withConverter<MovieQuote>(
        //   fromFirestore: (snapshot, _) => MovieQuote.from(snapshot),
        //   toFirestore: (movieQuote, _) => movieQuote.toMap(),
        // )
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      // .listen((QuerySnapshot<MovieQuote> querySnapshot) {
      // lastestMovieQuotes = querySnapshot.docs.map((e) => (e as MovieQuote)).toList();
      lastestMovieQuotes =
          querySnapshot.docs.map((doc) => MovieQuote.from(doc)).toList();
      observer();
      // print(lastestMovieQuotes);
    }, onError: (error) {
      print("Error listening $error");
    });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }
}
