import 'package:get_it/get_it.dart';

GetIt? serviceLocator;
void setupServiceLocator() {
  try {
    serviceLocator = GetIt.instance;
  } catch (e) {
    serviceLocator = GetIt.instance;
  }
}