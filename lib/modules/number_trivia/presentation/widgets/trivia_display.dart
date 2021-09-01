import 'package:flutter/material.dart';
import 'package:trivia_tdd_app/modules/number_trivia/domain/entities/number_trivia_entity.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTriviaEntity numberTrivia;

  const TriviaDisplay({Key key, @required this.numberTrivia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                numberTrivia.number.toString(),
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  numberTrivia.text,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
