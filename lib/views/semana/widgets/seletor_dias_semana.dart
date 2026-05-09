import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/dia_semana.dart';
import '../../../core/theme/cores_app.dart';
import '../../../core/utils/formatador_data.dart';
import '../../../viewmodels/semana_viewmodel.dart';

class SeletorDiasSemana extends StatelessWidget {
  const SeletorDiasSemana({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SemanaViewModel>();
    final hoje = DateTime.now();
    final diaSelecionado = viewModel.diaSelecionado;

    final diasDaSemana = _obterDiasDaSemana(diaSelecionado);

    return SizedBox(
      height: 72,
      child: ListView.separated(
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

  List<DateTime> _obterDiasDaSemana(DateTime referencia) {
    final domingo = referencia.subtract(Duration(days: referencia.weekday % 7));
    return List.generate(7, (i) => domingo.add(Duration(days: i)));
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
    final diaSemana = diaDaData(data);

    Color fundo;
    Color corTexto;

    if (selecionado) {
      fundo = CoresApp.diaSelecionado;
      corTexto = Colors.white;
    } else if (ehHoje) {
      fundo = CoresApp.diaAtual;
      corTexto = CoresApp.primaria;
    } else {
      fundo = CoresApp.fundoCard;
      corTexto = CoresApp.textoPrimario;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        decoration: BoxDecoration(
          color: fundo,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado ? CoresApp.diaSelecionado : CoresApp.divisor,
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
