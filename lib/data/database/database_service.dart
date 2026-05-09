import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'migrations/migracao.dart';
import 'migrations/migracao_001_criar_tabelas.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  static const _nomeBanco = 'myweek.db';

  final List<Migracao> _migracoes = [
    Migracao001CriarTabelas(),
  ];

  int get _versaoAtual => _migracoes.map((m) => m.versao).reduce((a, b) => a > b ? a : b);

  Database? _db;

  Future<Database> get db async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final caminho = join(await getDatabasesPath(), _nomeBanco);
    return openDatabase(
      caminho,
      version: _versaoAtual,
      onCreate: (db, _) => _executarTodas(db, desde: 0),
      onUpgrade: (db, versaoAntiga, _) => _executarTodas(db, desde: versaoAntiga),
    );
  }

  Future<void> _executarTodas(Database db, {required int desde}) async {
    final pendentes = _migracoes.where((m) => m.versao > desde).toList()
      ..sort((a, b) => a.versao.compareTo(b.versao));
    for (final migracao in pendentes) {
      await migracao.executar(db);
    }
  }
}
