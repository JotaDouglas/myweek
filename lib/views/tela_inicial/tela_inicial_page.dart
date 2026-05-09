import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enums/periodo_dia.dart';
import '../../core/theme/cores_app.dart';
import '../../core/utils/formatador_data.dart';
import '../../viewmodels/semana_viewmodel.dart';
import '../semana/semana_page.dart';
import 'widgets/indicador_progresso_diario.dart';

class TelaInicialPage extends StatefulWidget {
  const TelaInicialPage({super.key});

  @override
  State<TelaInicialPage> createState() => _TelaInicialPageState();
}

class _TelaInicialPageState extends State<TelaInicialPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SemanaViewModel>().inicializar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SemanaViewModel>();
    final periodo = periodoAtual();
    final tema = _temaDoPeriodo(periodo);

    final total = vm.metasDoDia.length;
    final concluidas = vm.metasDoDia.where((m) => m.concluida).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _cabecalho(tema),
              const SizedBox(height: 20),
              _cartaoSaudacao(tema),
              const SizedBox(height: 28),
              const Text(
                'Progresso de hoje',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 12),
              IndicadorProgressoDiario(
                total: total,
                concluidas: concluidas,
                corAccent: tema.corAccent,
              ),
              const SizedBox(height: 28),
              _botaoVerMetas(tema),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cabecalho(_TemaPeriodo tema) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tema.saudacaoCurta,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7A7A9D),
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text(
              'My Week',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF1A1A2E),
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _cartaoSaudacao(_TemaPeriodo tema) {
    final hoje = DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: tema.gradiente,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(tema.icone, color: tema.corTexto, size: 40),
              const SizedBox(height: 10),
              Text(
                tema.saudacao,
                style: TextStyle(
                  color: tema.corTexto,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatarDataExtenso(hoje),
                style: TextStyle(
                  color: tema.corTexto.withValues(alpha: 0.65),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            hoje.day.toString(),
            style: TextStyle(
              color: tema.corTexto.withValues(alpha: 0.15),
              fontSize: 80,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _botaoVerMetas(_TemaPeriodo tema) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SemanaPage()),
        );
        if (mounted) context.read<SemanaViewModel>().inicializar();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: tema.corAccent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: tema.corAccent.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ver metas do dia',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  _TemaPeriodo _temaDoPeriodo(PeriodoDia periodo) {
    switch (periodo) {
      case PeriodoDia.manha:
        return const _TemaPeriodo(
          gradiente: [CoresApp.fundoManha1, CoresApp.fundoManha2],
          corTexto: CoresApp.textoManha,
          corAccent: CoresApp.accentManha,
          icone: Icons.wb_sunny_rounded,
          saudacao: 'Bom dia!',
          saudacaoCurta: 'Bom dia,',
        );
      case PeriodoDia.tarde:
        return const _TemaPeriodo(
          gradiente: [CoresApp.fundoTarde1, CoresApp.fundoTarde2],
          corTexto: CoresApp.textoTarde,
          corAccent: CoresApp.accentTarde,
          icone: Icons.light_mode_rounded,
          saudacao: 'Boa tarde!',
          saudacaoCurta: 'Boa tarde,',
        );
      case PeriodoDia.noite:
        return const _TemaPeriodo(
          gradiente: [CoresApp.fundoNoite1, CoresApp.fundoNoite2],
          corTexto: CoresApp.textoNoite,
          corAccent: CoresApp.accentNoite,
          icone: Icons.nightlight_round,
          saudacao: 'Boa noite!',
          saudacaoCurta: 'Boa noite,',
        );
    }
  }
}

class _TemaPeriodo {
  final List<Color> gradiente;
  final Color corTexto;
  final Color corAccent;
  final IconData icone;
  final String saudacao;
  final String saudacaoCurta;

  const _TemaPeriodo({
    required this.gradiente,
    required this.corTexto,
    required this.corAccent,
    required this.icone,
    required this.saudacao,
    required this.saudacaoCurta,
  });
}
