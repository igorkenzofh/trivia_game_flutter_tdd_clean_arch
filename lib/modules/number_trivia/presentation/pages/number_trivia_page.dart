import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_tdd_app/modules/number_trivia/presentation/bloc/bloc.dart';
import 'package:trivia_tdd_app/modules/number_trivia/presentation/widgets/widgets.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NumberTrivia'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is Empty) {
                      return MessageDisplay(
                        message: 'Start searching...',
                      );
                    } else if (state is Loading) {
                      return LoadingWidget();
                    } else if (state is Loaded) {
                      return TriviaDisplay(numberTrivia: state.trivia);
                    } else if (state is Error) {
                      return MessageDisplay(message: state.errorMessage);
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
