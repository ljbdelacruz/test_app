import 'package:hive/hive.dart';

abstract class ICounterLocalDatasource {
  int getCounterValue();
  void incrementCounter();
  void decrementCounter();
}


class CounterLocalDatasource implements ICounterLocalDatasource {
  final Box<int> counterBox;
  CounterLocalDatasource(this.counterBox);
  
  @override
  void decrementCounter() {
    final currentValue = getCounterValue();
    counterBox.put('count', currentValue - 1);
  }
  
  @override
  int getCounterValue() {
    return counterBox.get('count', defaultValue: 0)!;
  }
  
  @override
  void incrementCounter() {
    final currentValue = getCounterValue();
    counterBox.put('count', currentValue + 1);
  }






}