import '../../models/meta_diaria.dart';
import '../../models/meta_recorrente.dart';

abstract class MetaRepository {
  Future<List<MetaDiaria>> buscarMetasDoDia(DateTime data);
  Future<void> salvarMetaDiaria(MetaDiaria meta);
  Future<void> alternarConclusaoDaMeta(String id);
  Future<void> removerMetaDiaria(String id);
  Future<List<MetaRecorrente>> buscarMetasRecorrentes();
  Future<void> salvarMetaRecorrente(MetaRecorrente meta);
  Future<void> alternarAtivacaoDaMetaRecorrente(String id);
  Future<void> removerMetaRecorrente(String id);
  Future<bool> existeMetaDiariaDaRecorrencia(
    String idMetaRecorrente,
    DateTime data,
  );
}
