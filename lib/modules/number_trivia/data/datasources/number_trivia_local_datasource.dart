import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_tdd_app/core/error/exceptions.dart';
import 'package:trivia_tdd_app/modules/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the last cached NumberTrivia which was gotten the last time the user had connection
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const cachedNumberTrivia = """ 
{
  "text":"Test Text.",
  "number": 1,
  "found": true,
  "type" : "trivia"
}
""";

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.get(cachedNumberTrivia);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
        cachedNumberTrivia, jsonEncode(triviaToCache.toJson()));
  }
}
