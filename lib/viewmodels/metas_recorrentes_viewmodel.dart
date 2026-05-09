import 'package:flutter/material.dart';

import '../core/enums/dia_semana.dart';
import '../core/utils/gerador_id.dart';
import '../data/repositories/meta_repository.dart';
import '../models/meta_recorrente.dart';

class MetasRecorrentesViewModel extends ChangeNotifier {
  final MetaRepository _repository;

  MetasRecorrentesViewModel(this._repository);

  List<MetaRecorrente> _metasRecorrentes = [];

  List<MetaRecorrente> get metasRecorrentes =>
      List.unmodifiable(_metasRecorrentes);

  Future<void> carregarMetasRecorrentes() async {
    _metasRecorrentes = await _repository.buscarMetasRecorrentes();
    notifyListeners();
  }

  Future<void> criarMetaRecorrente(
    String titulo,
    List<DiaSemana> dias,
  ) async {
    await _repository.salvarMetaRecorrente(
      MetaRecorrente(
        id: gerarId(),
        titulo: titulo,
        diasDaSemana: dias,
      ),
    );
    await carregarMetasRecorrentes();
  }

  Future<void> alternarAtivacaoDaMetaRecorrente(String id) async {
    await _repository.alternarAtivacaoDaMetaRecorrente(id);
    await carregarMetasRecorrentes();
  }

  Future<void> removerMetaRecorrente(String id) async {
    await _repository.removerMetaRecorrente(id);
    await carregarMetasRecorrentes();
  }
}
