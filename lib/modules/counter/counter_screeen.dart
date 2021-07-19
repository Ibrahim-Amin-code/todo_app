import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/counter/cubit/cubit.dart';
import 'package:todo_app/modules/counter/cubit/states.dart';

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterCubit(),
      child: BlocConsumer<CounterCubit, CounterStates>(
        listener: (context, state) {
          if (state is CounterMinusState) {
            // print('You are in MinusState ${state.counter}');
          } else if (state is CounterPlusState) {
            //  print('You are in PlusState ${state.counter}');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Counter'),
            ),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        // counter--;
                        CounterCubit.get(context).munis();
                      },
                      child: Text('MIUNS')),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      '${CounterCubit.get(context).counter}',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        //   counter++;
                        CounterCubit.get(context).plus();
                      },
                      child: Text('PLUS')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
