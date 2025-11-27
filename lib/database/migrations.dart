import 'package:floor/floor.dart';
import 'app_database.dart';

final migration1to2 = Migration(1, 2, (database) async {
  await database.execute('ALTER TABLE products RENAME COLUMN price TO base_price');
  await database.execute('ALTER TABLE products ADD COLUMN discount_percentage REAL');
  await database.execute('ALTER TABLE products ADD COLUMN has_global_discount INTEGER NOT NULL DEFAULT 0');

  await database.execute('''
    CREATE TABLE IF NOT EXISTS options (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      product_id INTEGER NOT NULL,
      name TEXT NOT NULL,
      price REAL NOT NULL,
      type TEXT NOT NULL,
      is_active INTEGER NOT NULL DEFAULT 1,
      FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
    )
  ''');
});