import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/cores_app.dart';
import '../../../core/utils/formatador_data.dart';
import '../../../viewmodels/semana_viewmodel.dart';

class FormularioMetaDiaria extends StatefulWidget {
  const FormularioMetaDiaria({super.key});

  @override
  State<FormularioMetaDiaria> createState() => _FormularioMetaDiariaState();
}

class _FormularioMetaDiariaState extends State<FormularioMetaDiaria> {
  final _controller = TextEditingController();
  late DateTime _dataSelecionada;

  @override
  void initState() {
    super.initState();
    _dataSelecionada = context.read<SemanaViewModel>().diaSelecionado;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final cores = context.cores;
    final hoje = DateTime.now();
    final resultado = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: hoje.subtract(const Duration(days: 365)),
      lastDate: hoje.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: cores.primaria,
            brightness: Theme.of(context).brightness,
          ),
        ),
        child: child!,
      ),
    );
    if (resultado != null) {
      setState(() => _dataSelecionada = resultado);
    }
  }

  void _salvar() {
    final titulo = _controller.text.trim();
    if (titulo.isEmpty) return;
    context
        .read<SemanaViewModel>()
        .adicionarMetaManual(titulo, data: _dataSelecionada);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

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
          Text(
            'Nova meta',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cores.textoPrimario,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Ex: Revisar anotações',
              hintStyle: TextStyle(color: cores.textoSecundario),
              filled: true,
              fillColor: cores.fundo,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (_) => _salvar(),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _selecionarData,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cores.fundo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: cores.primaria,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    formatarDataExtenso(_dataSelecionada),
                    style: TextStyle(fontSize: 14, color: cores.textoPrimario),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, size: 18, color: cores.textoSecundario),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _salvar,
              style: FilledButton.styleFrom(
                backgroundColor: cores.primaria,
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
