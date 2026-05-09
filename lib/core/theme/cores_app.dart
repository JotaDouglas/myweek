import 'package:flutter/material.dart';

class CoresApp {
  final Color fundo;
  final Color fundoCard;
  final Color primaria;
  final Color primariaSuave;
  final Color textoPrimario;
  final Color textoSecundario;
  final Color divisor;
  final Color metaConcluida;
  final Color diaSelecionado;
  final Color diaAtual;

  static const Color destrutivo = Color(0xFFD94F4F);

  const CoresApp._({
    required this.fundo,
    required this.fundoCard,
    required this.primaria,
    required this.primariaSuave,
    required this.textoPrimario,
    required this.textoSecundario,
    required this.divisor,
    required this.metaConcluida,
    required this.diaSelecionado,
    required this.diaAtual,
  });

  static const CoresApp _claro = CoresApp._(
    fundo: Color(0xFFF7F7F5),
    fundoCard: Color(0xFFFFFFFF),
    primaria: Color(0xFF4A7C59),
    primariaSuave: Color(0xFFD4EAD9),
    textoPrimario: Color(0xFF1A1A1A),
    textoSecundario: Color(0xFF7A7A7A),
    divisor: Color(0xFFEAEAEA),
    metaConcluida: Color(0xFFB0C9B5),
    diaSelecionado: Color(0xFF4A7C59),
    diaAtual: Color(0xFFD4EAD9),
  );

  static const CoresApp _escuro = CoresApp._(
    fundo: Color(0xFF0F0F0E),
    fundoCard: Color(0xFF1A1A18),
    primaria: Color(0xFF5B9A6E),
    primariaSuave: Color(0xFF1D3226),
    textoPrimario: Color(0xFFEDEDEB),
    textoSecundario: Color(0xFF888885),
    divisor: Color(0xFF252523),
    metaConcluida: Color(0xFF3A5642),
    diaSelecionado: Color(0xFF5B9A6E),
    diaAtual: Color(0xFF1D3226),
  );

  static CoresApp of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? _escuro : _claro;
  }
}

extension CoresTheme on BuildContext {
  CoresApp get cores => CoresApp.of(this);
}
