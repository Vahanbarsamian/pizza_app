import 'package:drift/drift.dart';

// Nouvelle table pour la bibliothèque d'ingrédients
@DataClassName('Ingredient')
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get category => text().nullable()();
}
