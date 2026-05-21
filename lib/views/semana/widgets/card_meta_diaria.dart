import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/cores_app.dart';
import '../../../core/widgets/dialogo_app.dart';
import 'formulario_meta_diaria.dart';
import '../../../models/meta_diaria.dart';
import '../../../viewmodels/semana_viewmodel.dart';

class CardMetaDiaria extends StatelessWidget {
  final MetaDiaria meta;

  const CardMetaDiaria({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cores.fundoCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cores.divisor),
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
              color: meta.concluida ? cores.primaria : Colors.transparent,
              border: Border.all(
                color: meta.concluida ? cores.primaria : cores.textoSecundario,
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
            color: meta.concluida ? cores.textoSecundario : cores.textoPrimario,
            decoration:
                meta.concluida ? TextDecoration.lineThrough : TextDecoration.none,
            decorationColor: cores.textoSecundario,
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, size: 20, color: cores.textoSecundario),
          onSelected: (value) {
            if (value == 'editar') _abrirEdicao(context, cores);
            if (value == 'excluir') _confirmarRemocao(context);
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'editar',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 18, color: cores.textoPrimario),
                  const SizedBox(width: 10),
                  Text('Editar', style: TextStyle(color: cores.textoPrimario)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'excluir',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  const SizedBox(width: 10),
                  const Text('Excluir', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirEdicao(BuildContext context, CoresApp cores) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cores.fundoCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FormularioMetaDiaria(metaParaEditar: meta),
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
