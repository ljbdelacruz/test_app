import 'package:dartz/dartz.dart';
import 'package:test_app/core/failure.dart';
import 'package:test_app/core/success.dart';
import 'package:test_app/feature/counter/data/counter_local_datasource.dart';

class CounterRepository {
  final ICounterLocalDatasource localDS;
  int _counter = 0;
  CounterRepository(this.localDS){
    _counter = localDS.getCounterValue();
  }

  int getCounterValue() {
    return _counter;
  }

  Either<Failure, Success> incrementCounter() {
    try {
      _counter++;
      localDS.incrementCounter();
      return Right(RepositorySuccess());
    }catch(e){
      return Left(RepositoryFailure());
    }
  }

  Either<Failure, Success> decrementCounter() {
    try{
      _counter--;
      localDS.decrementCounter();
      return Right(RepositorySuccess());
    }catch(e){
      return Left(RepositoryFailure());
    }
  }
}