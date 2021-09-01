import 'package:flutter/material.dart';
import 'package:trivia_tdd_app/injection_container.dart';
import 'package:trivia_tdd_app/modules/number_trivia/presentation/pages/number_trivia_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              primary: Colors.white, backgroundColor: Colors.green.shade800),
        ),
      ),
      home: NumberTriviaPage(),
    );
  }
}
