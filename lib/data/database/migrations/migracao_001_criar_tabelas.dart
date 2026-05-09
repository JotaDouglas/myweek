import 'package:sqflite/sqflite.dart';

import 'migracao.dart';

class Migracao001CriarTabelas implements Migracao {
  @override
  int get versao => 1;

  @override
  Future<void> executar(Database db) async {
    await db.execute('''
      CREATE TABLE metas_recorrentes (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        dias_da_semana TEXT NOT NULL,
        ativa INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE metas_diarias (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        data TEXT NOT NULL,
        concluida INTEGER NOT NULL DEFAULT 0,
        origem TEXT NOT NULL,
        id_meta_recorrente TEXT
      )
    ''');
  }
}
