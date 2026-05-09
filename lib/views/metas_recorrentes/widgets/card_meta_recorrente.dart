import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/cores_app.dart';
import '../../../core/widgets/dialogo_app.dart';
import '../../../models/meta_recorrente.dart';
import '../../../viewmodels/metas_recorrentes_viewmodel.dart';

class CardMetaRecorrente extends StatelessWidget {
  final MetaRecorrente meta;

  const CardMetaRecorrente({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final dias = meta.diasDaSemana.map((d) => d.nome).join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cores.fundoCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cores.divisor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        title: Text(
          meta.titulo,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: meta.ativa ? cores.textoPrimario : cores.textoSecundario,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            dias,
            style: TextStyle(fontSize: 12, color: cores.textoSecundario),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: meta.ativa,
              activeThumbColor: cores.primaria,
              onChanged: (_) {
                context
                    .read<MetasRecorrentesViewModel>()
                    .alternarAtivacaoDaMetaRecorrente(meta.id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, size: 20, color: cores.textoSecundario),
              onPressed: () => _confirmarRemocao(context),
            ),
          ],
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
      context
          .read<MetasRecorrentesViewModel>()
          .removerMetaRecorrente(meta.id);
    }
  }
}
