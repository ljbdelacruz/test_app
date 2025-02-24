import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:test_app/app_di.dart';
import 'package:test_app/core/failure.dart';
import 'package:test_app/feature/counter/data/counter_local_datasource.dart';

void setupCounterDependencies() {
  var hive = Hive.box<int>('counterBox');
  serviceLocator?.registerLazySingleton<ICounterLocalDatasource>(() => CounterLocalDatasource(hive));
}

Either<Failure, ICounterLocalDatasource> getCounterLocalDS() {
  try {
    return Right(serviceLocator!<ICounterLocalDatasource>());
  } catch (e) {
    return Left(DependenciesFailure());
  }
}