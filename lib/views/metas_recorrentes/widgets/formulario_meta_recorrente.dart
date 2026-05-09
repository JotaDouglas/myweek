import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/dia_semana.dart';
import '../../../core/theme/cores_app.dart';
import '../../../viewmodels/metas_recorrentes_viewmodel.dart';

class FormularioMetaRecorrente extends StatefulWidget {
  const FormularioMetaRecorrente({super.key});

  @override
  State<FormularioMetaRecorrente> createState() =>
      _FormularioMetaRecorrenteState();
}

class _FormularioMetaRecorrenteState extends State<FormularioMetaRecorrente> {
  final _controller = TextEditingController();
  final Set<DiaSemana> _diasSelecionados = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _salvar() {
    final titulo = _controller.text.trim();
    if (titulo.isEmpty || _diasSelecionados.isEmpty) return;
    context.read<MetasRecorrentesViewModel>().criarMetaRecorrente(
          titulo,
          _diasSelecionados.toList(),
        );
    Navigator.of(context).pop();
  }

  void _toggleDia(DiaSemana dia) {
    setState(() {
      if (_diasSelecionados.contains(dia)) {
        _diasSelecionados.remove(dia);
      } else {
        _diasSelecionados.add(dia);
      }
    });
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
            'Nova meta recorrente',
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
              hintText: 'Ex: Meditação',
              hintStyle: const TextStyle(color: CoresApp.textoSecundario),
              filled: true,
              fillColor: CoresApp.fundo,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Dias da semana',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: CoresApp.textoSecundario,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: DiaSemana.values.map((dia) {
              final selecionado = _diasSelecionados.contains(dia);
              return GestureDetector(
                onTap: () => _toggleDia(dia),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selecionado
                        ? CoresApp.primaria
                        : CoresApp.fundo,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selecionado
                          ? CoresApp.primaria
                          : CoresApp.divisor,
                    ),
                  ),
                  child: Text(
                    dia.nome,
                    style: TextStyle(
                      fontSize: 13,
                      color: selecionado
                          ? Colors.white
                          : CoresApp.textoPrimario,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
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
              child: const Text('Salvar'),
            ),
          ),
        ],
      ),
    );
  }
}
