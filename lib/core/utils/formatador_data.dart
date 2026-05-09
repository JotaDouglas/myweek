import '../enums/dia_semana.dart';

String formatarData(DateTime data) {
  final dia = diaDaData(data);
  final mes = data.month.toString().padLeft(2, '0');
  final diaMes = data.day.toString().padLeft(2, '0');
  return '${dia.nomeCompleto}, $diaMes/$mes';
}

bool mesmoDia(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
