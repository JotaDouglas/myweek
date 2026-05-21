import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/cores_app.dart';
import '../../core/utils/formatador_data.dart';
import '../../viewmodels/semana_viewmodel.dart';
import 'widgets/card_meta_diaria.dart';
import 'widgets/formulario_meta_diaria.dart';
import 'widgets/seletor_dias_semana.dart';

class SemanaPage extends StatefulWidget {
  const SemanaPage({super.key});

  @override
  State<SemanaPage> createState() => _SemanaPageState();
}

class _SemanaPageState extends State<SemanaPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SemanaViewModel>().inicializar();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _abrirCalendario() async {
    final cores = context.cores;
    final viewModel = context.read<SemanaViewModel>();
    final hoje = DateTime.now();
    final resultado = await showDatePicker(
      context: context,
      initialDate: viewModel.diaSelecionado,
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
    if (resultado != null && context.mounted) {
      viewModel.selecionarDia(resultado);
    }
  }

  void _abrirFormulario() {
    final cores = context.cores;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cores.fundoCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FormularioMetaDiaria(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final viewModel = context.watch<SemanaViewModel>();

    return Scaffold(
      backgroundColor: cores.fundo,
      appBar: AppBar(
        backgroundColor: cores.fundo,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month_outlined, color: cores.textoPrimario),
            onPressed: _abrirCalendario,
          ),
        ],
        title: Text(
          'My Week',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: cores.textoPrimario,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const SeletorDiasSemana(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  formatarData(viewModel.diaSelecionado),
                  style: TextStyle(
                    fontSize: 14,
                    color: cores.textoSecundario,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  '${viewModel.metasDoDia.where((m) => m.concluida).length}/${viewModel.metasDoDia.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: cores.textoSecundario,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: viewModel.metasDoDia.isEmpty
                ? _EstadoVazio()
                : Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: viewModel.metasDoDia.length,
                      itemBuilder: (context, index) => CardMetaDiaria(
                        meta: viewModel.metasDoDia[index],
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: Icon(Icons.add_rounded, size: 18, color: cores.primaria),
                label: Text(
                  'Nova meta',
                  style: TextStyle(color: cores.primaria),
                ),
                onPressed: _abrirFormulario,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: cores.primaria),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Nenhuma meta para este dia',
        style: TextStyle(color: context.cores.textoSecundario, fontSize: 14),
      ),
    );
  }
}
