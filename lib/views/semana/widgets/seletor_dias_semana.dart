import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/dia_semana.dart';
import '../../../core/theme/cores_app.dart';
import '../../../core/utils/formatador_data.dart';
import '../../../viewmodels/semana_viewmodel.dart';

class SeletorDiasSemana extends StatefulWidget {
  const SeletorDiasSemana({super.key});

  @override
  State<SeletorDiasSemana> createState() => _SeletorDiasSemanaState();
}

class _SeletorDiasSemanaState extends State<SeletorDiasSemana> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ajustarScrollInicial();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _ajustarScrollInicial() {
    final hoje = DateTime.now();
    // weekday % 7 → 0=Dom, 1=Seg, 2=Ter, 3=Qua, 4=Qui, 5=Sex, 6=Sáb
    final posicaoNaSemana = hoje.weekday % 7;
    if (posicaoNaSemana > 3) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  List<DateTime> _obterDiasDaSemana(DateTime referencia) {
    final domingo = referencia.subtract(Duration(days: referencia.weekday % 7));
    return List.generate(7, (i) => domingo.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SemanaViewModel>();
    final hoje = DateTime.now();
    final diaSelecionado = viewModel.diaSelecionado;

    final diasDaSemana = _obterDiasDaSemana(diaSelecionado);

    return SizedBox(
      height: 72,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: diasDaSemana.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final dia = diasDaSemana[index];
          final selecionado = mesmoDia(dia, diaSelecionado);
          final ehHoje = mesmoDia(dia, hoje);

          return _BotaoDia(
            data: dia,
            selecionado: selecionado,
            ehHoje: ehHoje,
            onTap: () => viewModel.selecionarDia(dia),
          );
        },
      ),
    );
  }
}

class _BotaoDia extends StatelessWidget {
  final DateTime data;
  final bool selecionado;
  final bool ehHoje;
  final VoidCallback onTap;

  const _BotaoDia({
    required this.data,
    required this.selecionado,
    required this.ehHoje,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final diaSemana = diaDaData(data);

    Color fundo;
    Color corTexto;

    if (selecionado) {
      fundo = cores.diaSelecionado;
      corTexto = Colors.white;
    } else if (ehHoje) {
      fundo = cores.diaAtual;
      corTexto = cores.primaria;
    } else {
      fundo = cores.fundoCard;
      corTexto = cores.textoPrimario;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        decoration: BoxDecoration(
          color: fundo,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado ? cores.diaSelecionado : cores.divisor,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              diaSemana.nome,
              style: TextStyle(
                fontSize: 11,
                color: corTexto,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.day.toString(),
              style: TextStyle(
                fontSize: 16,
                color: corTexto,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
