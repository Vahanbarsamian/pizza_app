import 'package:drift/drift.dart';
import '../../option.dart';
import '../app_database.dart';

part 'option_dao.g.dart';

@DriftAccessor(tables: [Options])
class OptionDao extends DatabaseAccessor<AppDatabase> with _$OptionDaoMixin {
  OptionDao(AppDatabase db) : super(db);

  Future<List<Option>> getOptionsForProduct(int productId) {
    return (select(options)..where((o) => o.productId.equals(productId))).get();
  }

  Future<void> insertOption(Option option) => into(options).insert(option);
}
