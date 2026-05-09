import '../core/enums/origem_meta.dart';

class MetaDiaria {
  final String id;
  final String titulo;
  final DateTime data;
  bool concluida;
  final OrigemMeta origem;
  final String? idMetaRecorrente;

  MetaDiaria({
    required this.id,
    required this.titulo,
    required this.data,
    this.concluida = false,
    required this.origem,
    this.idMetaRecorrente,
  });
}
