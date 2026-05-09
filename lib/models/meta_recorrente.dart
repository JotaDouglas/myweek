import '../core/enums/dia_semana.dart';

class MetaRecorrente {
  final String id;
  final String titulo;
  final List<DiaSemana> diasDaSemana;
  bool ativa;

  MetaRecorrente({
    required this.id,
    required this.titulo,
    required this.diasDaSemana,
    this.ativa = true,
  });
}
