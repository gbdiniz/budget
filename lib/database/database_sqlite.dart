// ignore_for_file: avoid_print

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSqlite {
  Future<Database> openConnection() async {
    final databasePath = await getDatabasesPath();
    final databaseFinalPath = join(databasePath, 'DATABASE_PSD');

    return await openDatabase(
      databaseFinalPath,
      version: 2,
      onConfigure: (Database database) async {
        print('OnConfigure');
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (Database database, int version) {
        print('OnCreate');
        final batch = database.batch();

        batch.execute('''
          create table tabela(
            id Integer primary key autoincrement,
            historico TEXT,
            categoria TEXT,
            data TEXT,
            entrada REAL(12),
            saida REAL(12)
          )
        ''');

        batch.commit();
      },
      onUpgrade: (Database database, int oldVersion, int newVersion) {
        print('OnUpgrade');
      },
      onDowngrade: (Database database, int oldVersion, int newVersion) {
        print('OnDowngrade');
      },
    );
  }
}
