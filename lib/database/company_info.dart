import 'package:drift/drift.dart';

@DataClassName('CompanyInfoData')
class CompanyInfo extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get name => text().nullable()();
  TextColumn get presentation => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get facebookUrl => text().named('facebook_url').nullable()();
  TextColumn get instagramUrl => text().named('instagram_url').nullable()();
  TextColumn get xUrl => text().named('x_url').nullable()();
  TextColumn get whatsappPhone => text().named('whatsapp_phone').nullable()();
  // ✅ NOUVEAU: Champs pour les coordonnées GPS
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
