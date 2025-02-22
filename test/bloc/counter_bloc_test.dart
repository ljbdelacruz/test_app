import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hive/hive.dart';
import 'package:test_app/blocs/counter_bloc.dart';
import 'package:test_app/repository/counter_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CounterBloc', () {
    late CounterBloc counterBloc;
    late CounterRepository counterRepository;
    late Box<int> counterBox;
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp();
      Hive.init(tempDir.path);
      counterBox = await Hive.openBox<int>('counterBox');
      counterBox.put('count', 0);
      counterRepository = CounterRepository(counterBox);
      counterBloc = CounterBloc(counterRepository);
    });

    tearDown(() async {
      await counterBox.clear();
      await counterBox.close();
      await tempDir.delete(recursive: true);
      counterBloc.close();
    });

    test('initial state is CounterValue with initial count from Hive', () {
      expect(counterBloc.state, CounterValue(0));
    });

    blocTest<CounterBloc, CounterState>(
      'emits [CounterValue(1)] when IncrementCounter is added',
      build: () => counterBloc,
      act: (bloc) => bloc.add(IncrementCounter()),
      expect: () => [CounterValue(1)],
    );

    blocTest<CounterBloc, CounterState>(
      'emits [CounterValue(1), CounterValue(2)] when IncrementCounter is added twice',
      build: () => counterBloc,
      act: (bloc) {
        bloc.add(IncrementCounter());
        bloc.add(IncrementCounter());
      },
      expect: () => [CounterValue(1), CounterValue(2)],
    );

    blocTest<CounterBloc, CounterState>(
      'emits [CounterValue(-1)] when DecrementCounter is added',
      build: () => counterBloc,
      act: (bloc) => bloc.add(DecrementCounter()),
      expect: () => [CounterValue(-1)],
    );

    blocTest<CounterBloc, CounterState>(
      'emits [CounterValue(-1), CounterValue(-2)] when DecrementCounter is added twice',
      build: () => counterBloc,
      act: (bloc) {
        bloc.add(DecrementCounter());
        bloc.add(DecrementCounter());
      },
      expect: () => [CounterValue(-1), CounterValue(-2)],
    );
  });
}