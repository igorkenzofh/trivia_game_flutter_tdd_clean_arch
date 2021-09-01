import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_tdd_app/modules/number_trivia/presentation/bloc/bloc.dart';
import 'package:trivia_tdd_app/modules/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            _controller.text = value;
            print('_controller.text: ${_controller.text}');
          },
          onSubmitted: (_) {
            _addEventConcrete();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                child: Text(
                  'Get random trivia',
                ),
                style: TextButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: _addEventRandom,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextButton(
                child: Text(
                  'Search',
                ),
                onPressed: _addEventConcrete,
              ),
            )
          ],
        )
      ],
    );
  }

  void _clear() {
    _controller.clear();
  }

  void _addEventConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(_controller.text));
    _clear();
  }

  void _addEventRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
    _clear();
  }
}
