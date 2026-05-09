import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../core/enums/dia_semana.dart';
import '../../core/enums/origem_meta.dart';
import '../../models/meta_diaria.dart';
import '../../models/meta_recorrente.dart';
import '../database/database_service.dart';
import 'meta_repository.dart';

class MetaRepositorySqlite implements MetaRepository {
  final DatabaseService _databaseService;

  MetaRepositorySqlite(this._databaseService);

  @override
  Future<List<MetaDiaria>> buscarMetasDoDia(DateTime data) async {
    final db = await _databaseService.db;
    final rows = await db.query(
      'metas_diarias',
      where: 'data = ?',
      whereArgs: [_formatarData(data)],
    );
    return rows.map(_rowParaMetaDiaria).toList();
  }

  @override
  Future<void> salvarMetaDiaria(MetaDiaria meta) async {
    final db = await _databaseService.db;
    await db.insert(
      'metas_diarias',
      _metaDiariaParaRow(meta),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> alternarConclusaoDaMeta(String id) async {
    final db = await _databaseService.db;
    await db.rawUpdate(
      'UPDATE metas_diarias SET concluida = 1 - concluida WHERE id = ?',
      [id],
    );
  }

  @override
  Future<List<MetaRecorrente>> buscarMetasRecorrentes() async {
    final db = await _databaseService.db;
    final rows = await db.query('metas_recorrentes');
    return rows.map(_rowParaMetaRecorrente).toList();
  }

  @override
  Future<void> salvarMetaRecorrente(MetaRecorrente meta) async {
    final db = await _databaseService.db;
    await db.insert(
      'metas_recorrentes',
      _metaRecorrenteParaRow(meta),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> alternarAtivacaoDaMetaRecorrente(String id) async {
    final db = await _databaseService.db;
    await db.rawUpdate(
      'UPDATE metas_recorrentes SET ativa = 1 - ativa WHERE id = ?',
      [id],
    );
  }

  @override
  Future<void> removerMetaDiaria(String id) async {
    final db = await _databaseService.db;
    await db.delete('metas_diarias', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> removerMetaRecorrente(String id) async {
    final db = await _databaseService.db;
    await db.delete('metas_recorrentes', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<bool> existeMetaDiariaDaRecorrencia(String idMetaRecorrente, DateTime data) async {
    final db = await _databaseService.db;
    final rows = await db.query(
      'metas_diarias',
      columns: ['id'],
      where: 'id_meta_recorrente = ? AND data = ?',
      whereArgs: [idMetaRecorrente, _formatarData(data)],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  // --- conversões ---

  String _formatarData(DateTime data) =>
      '${data.year.toString().padLeft(4, '0')}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}';

  MetaDiaria _rowParaMetaDiaria(Map<String, dynamic> row) {
    return MetaDiaria(
      id: row['id'] as String,
      titulo: row['titulo'] as String,
      data: DateTime.parse(row['data'] as String),
      concluida: (row['concluida'] as int) == 1,
      origem: OrigemMeta.values.byName(row['origem'] as String),
      idMetaRecorrente: row['id_meta_recorrente'] as String?,
    );
  }

  Map<String, dynamic> _metaDiariaParaRow(MetaDiaria meta) => {
        'id': meta.id,
        'titulo': meta.titulo,
        'data': _formatarData(meta.data),
        'concluida': meta.concluida ? 1 : 0,
        'origem': meta.origem.name,
        'id_meta_recorrente': meta.idMetaRecorrente,
      };

  MetaRecorrente _rowParaMetaRecorrente(Map<String, dynamic> row) {
    final dias = (jsonDecode(row['dias_da_semana'] as String) as List)
        .map((d) => DiaSemana.values.byName(d as String))
        .toList();
    return MetaRecorrente(
      id: row['id'] as String,
      titulo: row['titulo'] as String,
      diasDaSemana: dias,
      ativa: (row['ativa'] as int) == 1,
    );
  }

  Map<String, dynamic> _metaRecorrenteParaRow(MetaRecorrente meta) => {
        'id': meta.id,
        'titulo': meta.titulo,
        'dias_da_semana': jsonEncode(meta.diasDaSemana.map((d) => d.name).toList()),
        'ativa': meta.ativa ? 1 : 0,
      };
}
