part of 'app_database.dart';

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
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();

  BoolColumn get ordersEnabled => boolean().named('orders_enabled').withDefault(const Constant(true))();
  TextColumn get closureMessageType => text().named('closure_message_type').nullable()();
  DateTimeColumn get closureStartDate => dateTime().named('closure_start_date').nullable()();
  DateTimeColumn get closureEndDate => dateTime().named('closure_end_date').nullable()();
  TextColumn get closureCustomMessage => text().named('closure_custom_message').nullable()();

  TextColumn get logoUrl => text().named('logo_url').nullable()();
  RealColumn get tvaRate => real().named('tva_rate').nullable()();
  
  TextColumn get googleUrl => text().named('google_url').nullable()();
  TextColumn get pagesJaunesUrl => text().named('pagesjaunes_url').nullable()();

  // ✅ AJOUT: Toggle global pour le paiement en ligne
  BoolColumn get isPaymentEnabled => boolean().named('is_payment_enabled').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
