import 'package:flutter/material.dart';

import '../theme/cores_app.dart';

class DialogoApp extends StatelessWidget {
  final String titulo;
  final String mensagem;
  final String labelConfirmar;
  final String labelCancelar;
  final bool destrutivo;
  final IconData? icone;

  const DialogoApp({
    super.key,
    required this.titulo,
    required this.mensagem,
    this.labelConfirmar = 'Confirmar',
    this.labelCancelar = 'Cancelar',
    this.destrutivo = false,
    this.icone,
  });

  static Future<bool> mostrar(
    BuildContext context, {
    required String titulo,
    required String mensagem,
    String labelConfirmar = 'Confirmar',
    String labelCancelar = 'Cancelar',
    bool destrutivo = false,
    IconData? icone,
  }) async {
    final resultado = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (_) => DialogoApp(
        titulo: titulo,
        mensagem: mensagem,
        labelConfirmar: labelConfirmar,
        labelCancelar: labelCancelar,
        destrutivo: destrutivo,
        icone: icone,
      ),
    );
    return resultado ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final corAcao = destrutivo ? CoresApp.destrutivo : cores.primaria;
    final corIconeFundo = destrutivo
        ? CoresApp.destrutivo.withValues(alpha: 0.1)
        : cores.primariaSuave;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          color: cores.fundoCard,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 28),
            if (icone != null) ...[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: corIconeFundo,
                  shape: BoxShape.circle,
                ),
                child: Icon(icone, size: 26, color: corAcao),
              ),
              const SizedBox(height: 20),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: cores.textoPrimario,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                mensagem,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: cores.textoSecundario,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Container(height: 1, color: cores.divisor),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _BotaoDialogo(
                      label: labelCancelar,
                      onTap: () => Navigator.of(context).pop(false),
                      cor: cores.textoSecundario,
                      negrito: false,
                    ),
                  ),
                  Container(width: 1, color: cores.divisor),
                  Expanded(
                    child: _BotaoDialogo(
                      label: labelConfirmar,
                      onTap: () => Navigator.of(context).pop(true),
                      cor: corAcao,
                      negrito: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotaoDialogo extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color cor;
  final bool negrito;

  const _BotaoDialogo({
    required this.label,
    required this.onTap,
    required this.cor,
    required this.negrito,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: negrito ? FontWeight.w600 : FontWeight.w400,
              color: cor,
            ),
          ),
        ),
      ),
    );
  }
}
