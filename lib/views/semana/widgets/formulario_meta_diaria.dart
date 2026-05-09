import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/cores_app.dart';
import '../../../viewmodels/semana_viewmodel.dart';

class FormularioMetaDiaria extends StatefulWidget {
  const FormularioMetaDiaria({super.key});

  @override
  State<FormularioMetaDiaria> createState() => _FormularioMetaDiariaState();
}

class _FormularioMetaDiariaState extends State<FormularioMetaDiaria> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _salvar() {
    final titulo = _controller.text.trim();
    if (titulo.isEmpty) return;
    context.read<SemanaViewModel>().adicionarMetaManual(titulo);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nova meta',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CoresApp.textoPrimario,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Ex: Revisar anotações',
              hintStyle: const TextStyle(color: CoresApp.textoSecundario),
              filled: true,
              fillColor: CoresApp.fundo,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (_) => _salvar(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _salvar,
              style: FilledButton.styleFrom(
                backgroundColor: CoresApp.primaria,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Adicionar'),
            ),
          ),
        ],
      ),
    );
  }
}
