part of 'app_database.dart';

@DataClassName('Announcement')
class Announcements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get announcementText => text().named('announcement_text').nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl => text().named('image_url').nullable()();
  TextColumn get conclusion => text().nullable()();
  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  TextColumn get type => text().withDefault(const Constant('Annonce'))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
}
