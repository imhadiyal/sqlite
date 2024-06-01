import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite/modals/user_modal.dart';

enum UserTable { id, name, email }

class DbHelper {
  DbHelper._();
  static final DbHelper dbHelper = DbHelper._();
  String dbName = "user.db";
  String tableName = "Users";
  late Database database;
  Logger logger = Logger();
  Future<void> initDb() async {
    // Path
    String dbPath = await getDatabasesPath();

    database = await openDatabase(
      '$dbPath/$dbName',
      // version
      version: 1,
      onCreate: (db, version) {
        String createTableQuery =
            """ CREATE TABLE IF NOT EXISTS $tableName (${UserTable.id.name} INTEGER PRIMARY KEY AUTOINCREMENT, ${UserTable.name.name} TEXT NOT NULL,${UserTable.email.name} TEXT NOT NULL);""";

        db
            .execute(createTableQuery)
            .then((value) => logger.i('table created'))
            .onError((error, stackTrace) => logger.e('ERROR: $error'));
      }, // onCreate

      onUpgrade: (db, v1, v2) {}, // onUpgrade
      onDowngrade: (db, v1, v2) {}, // onDowngrade
    ); // openDatabase
  }

  Future<void> insertData({required User user}) async {
    String sql =
        "INSERT INTO $tableName(${UserTable.id.name},${UserTable.name.name},${UserTable.email.name}) VALUES (?,?,?);";
    Map<String, dynamic> usermap = user.toMap;
    // usermap.remove('id');
    // await database.insert(tableName, usermap);

    await database
        .rawInsert(
          sql,
          [
            user.id,
            user.name,
            user.email,
          ],
        )
        .then(
          (value) => logger.i("user${user.name}"),
        )
        .onError(
          (error, stackTrace) => logger.e("error$error"),
        );
  }

  Future<void> updateData({required User user}) async {
    Map<String, dynamic> userMap = user.toMap;
    await database
        .update(tableName, userMap)
        .then(
          (value) => logger.i('User ${user.name} updated !!'),
        )
        .onError(
          (error, stackTrace) => logger.e('Update Error: $error'),
        );
  }

  Future<void> deleteData({required User user}) async {
    await database
        .delete(
          tableName,
          where: '${UserTable.id.name} = ?',
          whereArgs: [user.id],
        )
        .then(
          (value) => logger.i('Student ${user.name} deleted !!'),
        )
        .onError(
          (error, stackTrace) => logger.e('Delete Error: $error'),
        );
  }

  Future<List<User>> getAllData() async {
    List<Map> allData = await database.rawQuery('SELECT * FROM $tableName');

    return allData
        .map(
          (e) => User.fromMap(
            data: e,
          ),
        )
        .toList();
  }
}
