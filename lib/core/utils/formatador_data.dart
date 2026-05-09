import '../enums/dia_semana.dart';

String formatarData(DateTime data) {
  final dia = diaDaData(data);
  final mes = data.month.toString().padLeft(2, '0');
  final diaMes = data.day.toString().padLeft(2, '0');
  return '${dia.nomeCompleto}, $diaMes/$mes';
}

String formatarDataExtenso(DateTime data) {
  const meses = [
    'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
    'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
  ];
  final dia = diaDaData(data);
  final numero = data.day.toString().padLeft(2, '0');
  final mes = meses[data.month - 1];
  return '${dia.nomeCompleto}, $numero de $mes';
}

bool mesmoDia(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
