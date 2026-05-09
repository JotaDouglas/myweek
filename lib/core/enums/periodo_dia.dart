enum PeriodoDia { manha, tarde, noite }

PeriodoDia periodoAtual() {
  final hora = DateTime.now().hour;
  if (hora >= 5 && hora < 12) return PeriodoDia.manha;
  if (hora >= 12 && hora < 18) return PeriodoDia.tarde;
  return PeriodoDia.noite;
}
