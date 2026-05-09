import '../../core/enums/dia_semana.dart';
import '../../core/utils/formatador_data.dart';
import '../../core/utils/gerador_id.dart';
import '../../models/meta_diaria.dart';
import '../../models/meta_recorrente.dart';
import 'meta_repository.dart';

class MetaRepositoryMemoria implements MetaRepository {
  final List<MetaDiaria> _metasDiarias = [];
  final List<MetaRecorrente> _metasRecorrentes = [];

  MetaRepositoryMemoria() {
    _popularDadosIniciais();
  }

  void _popularDadosIniciais() {
    _metasRecorrentes.addAll([
      MetaRecorrente(
        id: gerarId(),
        titulo: 'Faculdade',
        diasDaSemana: [
          DiaSemana.segunda,
          DiaSemana.terca,
          DiaSemana.quarta,
          DiaSemana.quinta,
          DiaSemana.sexta,
        ],
      ),
      MetaRecorrente(
        id: gerarId(),
        titulo: 'Academia',
        diasDaSemana: [
          DiaSemana.segunda,
          DiaSemana.quarta,
          DiaSemana.sexta,
        ],
      ),
      MetaRecorrente(
        id: gerarId(),
        titulo: 'Estudar programação',
        diasDaSemana: DiaSemana.values,
      ),
    ]);
  }

  @override
  Future<List<MetaDiaria>> buscarMetasDoDia(DateTime data) async {
    return _metasDiarias.where((m) => mesmoDia(m.data, data)).toList();
  }

  @override
  Future<void> salvarMetaDiaria(MetaDiaria meta) async {
    _metasDiarias.add(meta);
  }

  @override
  Future<void> alternarConclusaoDaMeta(String id) async {
    final meta = _metasDiarias.firstWhere((m) => m.id == id);
    meta.concluida = !meta.concluida;
  }

  @override
  Future<List<MetaRecorrente>> buscarMetasRecorrentes() async {
    return List.unmodifiable(_metasRecorrentes);
  }

  @override
  Future<void> salvarMetaRecorrente(MetaRecorrente meta) async {
    _metasRecorrentes.add(meta);
  }

  @override
  Future<void> alternarAtivacaoDaMetaRecorrente(String id) async {
    final meta = _metasRecorrentes.firstWhere((m) => m.id == id);
    meta.ativa = !meta.ativa;
  }

  @override
  Future<void> removerMetaRecorrente(String id) async {
    _metasRecorrentes.removeWhere((m) => m.id == id);
  }

  @override
  Future<bool> existeMetaDiariaDaRecorrencia(
    String idMetaRecorrente,
    DateTime data,
  ) async {
    return _metasDiarias.any(
      (m) => m.idMetaRecorrente == idMetaRecorrente && mesmoDia(m.data, data),
    );
  }
}
