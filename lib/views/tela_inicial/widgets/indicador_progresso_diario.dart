import 'package:flutter/material.dart';

import '../../../core/theme/cores_app.dart';

class IndicadorProgressoDiario extends StatelessWidget {
  final int total;
  final int concluidas;

  const IndicadorProgressoDiario({
    super.key,
    required this.total,
    required this.concluidas,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final percentual = total == 0 ? 0.0 : concluidas / total;
    final percentualTexto = '${(percentual * 100).round()}%';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cores.fundoCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            height: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: percentual,
                    strokeWidth: 8,
                    backgroundColor: cores.primariaSuave,
                    valueColor: AlwaysStoppedAnimation<Color>(cores.primaria),
                  ),
                ),
                Text(
                  percentualTexto,
                  style: TextStyle(
                    color: cores.primaria,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$concluidas de $total concluídas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: cores.textoPrimario,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _mensagemMotivacional(percentual),
                  style: TextStyle(
                    fontSize: 13,
                    color: cores.textoSecundario,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _mensagemMotivacional(double percentual) {
    if (total == 0) return 'Nenhuma meta para hoje';
    if (percentual == 0.0) return 'Vamos começar!';
    if (percentual < 0.5) return 'Bom progresso, continue!';
    if (percentual < 1.0) return 'Quase lá, não pare!';
    return 'Dia completo! Parabéns!';
  }
}
