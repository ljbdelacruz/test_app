import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:test_app/feature/counter/blocs/counter_bloc.dart';
import 'package:test_app/feature/counter/data/counter_local_datasource.dart';
import 'package:test_app/feature/counter/repository/counter_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CounterBloc', () {
    late CounterBloc counterBloc;
    late CounterLocalDatasource counterLocalDatasource;
    late CounterRepository counterRepository;
    late Box<int> counterBox;
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp();
      Hive.init(tempDir.path);
      counterBox = await Hive.openBox<int>('counterBox');
      counterBox.put('counter', 0);
      counterLocalDatasource = CounterLocalDatasource(counterBox);
      counterRepository = CounterRepository(counterLocalDatasource);
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
      'emits [CounterValue(-1)] when DecrementCounter is added',
      build: () => counterBloc,
      act: (bloc) => bloc.add(DecrementCounter()),
      expect: () => [CounterValue(-1)],
    );
  });
}