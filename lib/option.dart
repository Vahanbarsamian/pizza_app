import 'package:drift/drift.dart';
import 'product.dart';

@DataClassName('Option')
class Options extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get type => text()(); // 'add' or 'remove'
}
