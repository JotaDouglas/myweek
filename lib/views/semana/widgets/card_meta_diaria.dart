import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/cores_app.dart';
import '../../../core/widgets/dialogo_app.dart';
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
        contentPadding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
        leading: GestureDetector(
          onTap: () =>
              context.read<SemanaViewModel>().alternarConclusaoDaMeta(meta.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: meta.concluida ? CoresApp.primaria : Colors.transparent,
              border: Border.all(
                color:
                    meta.concluida ? CoresApp.primaria : CoresApp.textoSecundario,
                width: 1.5,
              ),
            ),
            child: meta.concluida
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
        ),
        title: Text(
          meta.titulo,
          style: TextStyle(
            fontSize: 15,
            color:
                meta.concluida ? CoresApp.textoSecundario : CoresApp.textoPrimario,
            decoration:
                meta.concluida ? TextDecoration.lineThrough : TextDecoration.none,
            decorationColor: CoresApp.textoSecundario,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            size: 20,
            color: CoresApp.textoSecundario,
          ),
          onPressed: () => _confirmarRemocao(context),
        ),
      ),
    );
  }

  Future<void> _confirmarRemocao(BuildContext context) async {
    final confirmar = await DialogoApp.mostrar(
      context,
      titulo: 'Remover meta',
      mensagem: 'Deseja remover "${meta.titulo}"?',
      labelConfirmar: 'Remover',
      labelCancelar: 'Cancelar',
      destrutivo: true,
      icone: Icons.delete_outline,
    );
    if (confirmar && context.mounted) {
      context.read<SemanaViewModel>().removerMetaDiaria(meta.id);
    }
  }
}
