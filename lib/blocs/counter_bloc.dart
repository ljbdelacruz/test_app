// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/repository/counter_repository.dart';

// Events
abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class IncrementCounter extends CounterEvent {}

class DecrementCounter extends CounterEvent {}

// States
abstract class CounterState extends Equatable {
  const CounterState();

  @override
  List<Object> get props => [];
}

class CounterInitial extends CounterState {}

class CounterValue extends CounterState {
  final int value;

  const CounterValue(this.value);

  @override
  List<Object> get props => [value];
}

// BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final CounterRepository counterRepository;

  CounterBloc(this.counterRepository) : super(CounterInitial()) {
    on<IncrementCounter>((event, emit) {
      counterRepository.incrementCounter();
      final newValue = counterRepository.getCounterValue();
      emit(CounterValue(newValue));
    });

    on<DecrementCounter>((event, emit) {
      counterRepository.decrementCounter();
      final newValue = counterRepository.getCounterValue();
      emit(CounterValue(newValue));
    });

    final initialCount = counterRepository.getCounterValue();
    emit(CounterValue(initialCount));
  }
}