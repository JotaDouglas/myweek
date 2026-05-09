import 'package:flutter/material.dart';

import '../core/enums/dia_semana.dart';
import '../core/enums/origem_meta.dart';
import '../core/utils/gerador_id.dart';
import '../data/repositories/meta_repository.dart';
import '../models/meta_diaria.dart';

class SemanaViewModel extends ChangeNotifier {
  final MetaRepository _repository;

  SemanaViewModel(this._repository);

  DateTime _diaSelecionado = DateTime.now();
  List<MetaDiaria> _metasDoDia = [];

  DateTime get diaSelecionado => _diaSelecionado;
  List<MetaDiaria> get metasDoDia => List.unmodifiable(_metasDoDia);

  Future<void> selecionarDia(DateTime dia) async {
    _diaSelecionado = dia;
    await gerarMetasRecorrentesDoDia(dia);
    await _carregarMetasDoDia(dia);
    notifyListeners();
  }

  Future<void> inicializar() async {
    await selecionarDia(_diaSelecionado);
  }

  Future<void> gerarMetasRecorrentesDoDia(DateTime dia) async {
    final recorrentes = await _repository.buscarMetasRecorrentes();
    final diaDaSemana = diaDaData(dia);
    final ativas = recorrentes.where((r) => r.ativa);
    final dodia = ativas.where((r) => r.diasDaSemana.contains(diaDaSemana));

    for (final recorrente in dodia) {
      final jaExiste = await _repository.existeMetaDiariaDaRecorrencia(
        recorrente.id,
        dia,
      );
      if (!jaExiste) {
        await _repository.salvarMetaDiaria(
          MetaDiaria(
            id: gerarId(),
            titulo: recorrente.titulo,
            data: dia,
            origem: OrigemMeta.recorrente,
            idMetaRecorrente: recorrente.id,
          ),
        );
      }
    }
  }

  Future<void> _carregarMetasDoDia(DateTime dia) async {
    _metasDoDia = await _repository.buscarMetasDoDia(dia);
  }

  Future<void> adicionarMetaManual(String titulo) async {
    await _repository.salvarMetaDiaria(
      MetaDiaria(
        id: gerarId(),
        titulo: titulo,
        data: _diaSelecionado,
        origem: OrigemMeta.manual,
      ),
    );
    await _carregarMetasDoDia(_diaSelecionado);
    notifyListeners();
  }

  Future<void> alternarConclusaoDaMeta(String id) async {
    await _repository.alternarConclusaoDaMeta(id);
    await _carregarMetasDoDia(_diaSelecionado);
    notifyListeners();
  }
}
