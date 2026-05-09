import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/cores_app.dart';
import '../../viewmodels/metas_recorrentes_viewmodel.dart';
import 'widgets/card_meta_recorrente.dart';
import 'widgets/formulario_meta_recorrente.dart';

class MetasRecorrentesPage extends StatefulWidget {
  const MetasRecorrentesPage({super.key});

  @override
  State<MetasRecorrentesPage> createState() => _MetasRecorrentesPageState();
}

class _MetasRecorrentesPageState extends State<MetasRecorrentesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MetasRecorrentesViewModel>().carregarMetasRecorrentes();
    });
  }

  void _abrirFormulario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CoresApp.fundoCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<MetasRecorrentesViewModel>(),
        child: const FormularioMetaRecorrente(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MetasRecorrentesViewModel>();

    return Scaffold(
      backgroundColor: CoresApp.fundo,
      appBar: AppBar(
        backgroundColor: CoresApp.fundo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CoresApp.textoPrimario),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Metas recorrentes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: CoresApp.textoPrimario,
          ),
        ),
      ),
      body: viewModel.metasRecorrentes.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma meta recorrente cadastrada',
                style: TextStyle(
                  color: CoresApp.textoSecundario,
                  fontSize: 14,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: viewModel.metasRecorrentes.length,
              itemBuilder: (context, index) => CardMetaRecorrente(
                meta: viewModel.metasRecorrentes[index],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        backgroundColor: CoresApp.primaria,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
