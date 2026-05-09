enum DiaSemana {
  segunda,
  terca,
  quarta,
  quinta,
  sexta,
  sabado,
  domingo;

  String get nome {
    switch (this) {
      case DiaSemana.segunda:
        return 'Seg';
      case DiaSemana.terca:
        return 'Ter';
      case DiaSemana.quarta:
        return 'Qua';
      case DiaSemana.quinta:
        return 'Qui';
      case DiaSemana.sexta:
        return 'Sex';
      case DiaSemana.sabado:
        return 'Sáb';
      case DiaSemana.domingo:
        return 'Dom';
    }
  }

  String get nomeCompleto {
    switch (this) {
      case DiaSemana.segunda:
        return 'Segunda';
      case DiaSemana.terca:
        return 'Terça';
      case DiaSemana.quarta:
        return 'Quarta';
      case DiaSemana.quinta:
        return 'Quinta';
      case DiaSemana.sexta:
        return 'Sexta';
      case DiaSemana.sabado:
        return 'Sábado';
      case DiaSemana.domingo:
        return 'Domingo';
    }
  }
}

DiaSemana diaDaData(DateTime data) {
  switch (data.weekday) {
    case DateTime.monday:
      return DiaSemana.segunda;
    case DateTime.tuesday:
      return DiaSemana.terca;
    case DateTime.wednesday:
      return DiaSemana.quarta;
    case DateTime.thursday:
      return DiaSemana.quinta;
    case DateTime.friday:
      return DiaSemana.sexta;
    case DateTime.saturday:
      return DiaSemana.sabado;
    case DateTime.sunday:
    default:
      return DiaSemana.domingo;
  }
}
