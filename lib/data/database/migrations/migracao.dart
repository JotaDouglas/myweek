import 'package:sqflite/sqflite.dart';

abstract class Migracao {
  int get versao;
  Future<void> executar(Database db);
}
