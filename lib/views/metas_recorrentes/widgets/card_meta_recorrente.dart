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
    final dias = meta.diasDaSemana.map((d) => d.nome).join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: CoresApp.fundoCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.divisor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        title: Text(
          meta.titulo,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: meta.ativa ? CoresApp.textoPrimario : CoresApp.textoSecundario,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            dias,
            style: const TextStyle(
              fontSize: 12,
              color: CoresApp.textoSecundario,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: meta.ativa,
              activeThumbColor: CoresApp.primaria,
              onChanged: (_) {
                context
                    .read<MetasRecorrentesViewModel>()
                    .alternarAtivacaoDaMetaRecorrente(meta.id);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                size: 20,
                color: CoresApp.textoSecundario,
              ),
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
