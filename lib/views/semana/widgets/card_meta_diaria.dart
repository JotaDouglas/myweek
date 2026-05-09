import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/cores_app.dart';
import '../../../models/meta_diaria.dart';
import '../../../viewmodels/semana_viewmodel.dart';

class CardMetaDiaria extends StatelessWidget {
  final MetaDiaria meta;

  const CardMetaDiaria({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: CoresApp.fundoCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.divisor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          meta.titulo,
          style: TextStyle(
            fontSize: 15,
            color: meta.concluida
                ? CoresApp.textoSecundario
                : CoresApp.textoPrimario,
            decoration:
                meta.concluida ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        trailing: Checkbox(
          value: meta.concluida,
          activeColor: CoresApp.primaria,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (_) {
            context.read<SemanaViewModel>().alternarConclusaoDaMeta(meta.id);
          },
        ),
      ),
    );
  }
}
