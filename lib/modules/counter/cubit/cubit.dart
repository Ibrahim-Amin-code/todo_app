import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/counter/cubit/states.dart';

class CounterCubit extends Cubit<CounterStates>
{
  CounterCubit() : super(CounterInitialState());

  static CounterCubit  get(context) => BlocProvider.of(context);

  int counter = 1;

  void munis(){
    counter--;
    emit(CounterMinusState(counter));
  }
  void plus(){
    counter++;
    emit(CounterPlusState(counter));
  }

}