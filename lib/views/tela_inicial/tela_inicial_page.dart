import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enums/periodo_dia.dart';
import '../../core/theme/cores_app.dart';
import '../../core/utils/formatador_data.dart';
import '../../viewmodels/semana_viewmodel.dart';
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
    final info = _infoDoPeriodo(periodoAtual());

    final total = vm.metasDoDia.length;
    final concluidas = vm.metasDoDia.where((m) => m.concluida).length;

    return Scaffold(
      backgroundColor: CoresApp.fundo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _cabecalho(info),
              const SizedBox(height: 20),
              _cartaoSaudacao(info),
              const SizedBox(height: 16),
              _cardTotalSemana(vm.totalMetasDaSemana),
              const SizedBox(height: 28),
              const Text(
                'Progresso de hoje',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: CoresApp.textoPrimario,
                ),
              ),
              const SizedBox(height: 12),
              IndicadorProgressoDiario(total: total, concluidas: concluidas),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cabecalho(_InfoPeriodo info) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              info.saudacaoCurta,
              style: const TextStyle(
                fontSize: 14,
                color: CoresApp.textoSecundario,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text(
              'My Week',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: CoresApp.textoPrimario,
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
            color: CoresApp.textoPrimario,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _cartaoSaudacao(_InfoPeriodo info) {
    final hoje = DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: CoresApp.primaria,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(info.icone, color: Colors.white, size: 36),
              const SizedBox(height: 10),
              Text(
                info.saudacao,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatarDataExtenso(hoje),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            hoje.day.toString(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.15),
              fontSize: 80,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardTotalSemana(int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: CoresApp.primariaSuave,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.date_range_rounded,
              color: CoresApp.primaria,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total da semana',
                style: TextStyle(
                  fontSize: 13,
                  color: CoresApp.textoSecundario,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$total ${total == 1 ? 'meta' : 'metas'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CoresApp.textoPrimario,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _InfoPeriodo _infoDoPeriodo(PeriodoDia periodo) {
    switch (periodo) {
      case PeriodoDia.manha:
        return const _InfoPeriodo(
          icone: Icons.wb_sunny_rounded,
          saudacao: 'Bom dia!',
          saudacaoCurta: 'Bom dia,',
        );
      case PeriodoDia.tarde:
        return const _InfoPeriodo(
          icone: Icons.light_mode_rounded,
          saudacao: 'Boa tarde!',
          saudacaoCurta: 'Boa tarde,',
        );
      case PeriodoDia.noite:
        return const _InfoPeriodo(
          icone: Icons.nightlight_round,
          saudacao: 'Boa noite!',
          saudacaoCurta: 'Boa noite,',
        );
    }
  }
}

class _InfoPeriodo {
  final IconData icone;
  final String saudacao;
  final String saudacaoCurta;

  const _InfoPeriodo({
    required this.icone,
    required this.saudacao,
    required this.saudacaoCurta,
  });
}
