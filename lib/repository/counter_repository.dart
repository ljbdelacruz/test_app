import 'package:hive/hive.dart';

class CounterRepository {
  final Box<int> counterBox;

  CounterRepository(this.counterBox);

  int getCounterValue() {
    return counterBox.get('count', defaultValue: 0)!;
  }

  void incrementCounter() {
    final currentValue = getCounterValue();
    counterBox.put('count', currentValue + 1);
  }

  void decrementCounter() {
    final currentValue = getCounterValue();
    counterBox.put('count', currentValue - 1);
  }
}