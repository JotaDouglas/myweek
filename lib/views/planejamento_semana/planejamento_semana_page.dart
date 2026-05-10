import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enums/dia_semana.dart';
import '../../core/theme/cores_app.dart';
import '../../core/utils/formatador_data.dart';
import '../../models/meta_diaria.dart';
import '../../viewmodels/semana_viewmodel.dart';

class PlanejamentoSemanaPage extends StatefulWidget {
  const PlanejamentoSemanaPage({super.key});

  @override
  State<PlanejamentoSemanaPage> createState() => _PlanejamentoSemanaPageState();
}

class _PlanejamentoSemanaPageState extends State<PlanejamentoSemanaPage> {
  late final List<DateTime> _diasDaSemana;
  late final PageController _pageController;
  final ScrollController _seletorScroll = ScrollController();
  int _diaAtualIndex = 0;

  static const _chipWidth = 46.0;
  static const _chipSpacing = 8.0;
  static const _seletorPadding = 20.0;

  @override
  void initState() {
    super.initState();
    final hoje = DateTime.now();
    final inicio = hoje.subtract(Duration(days: hoje.weekday % 7));
    _diasDaSemana = List.generate(7, (i) => inicio.add(Duration(days: i)));
    _diaAtualIndex = hoje.weekday % 7;
    _pageController = PageController(initialPage: _diaAtualIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SemanaViewModel>().carregarSemanaCompleta();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _seletorScroll.dispose();
    super.dispose();
  }

  void _irParaDia(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _aoMudarPagina(int index) {
    setState(() => _diaAtualIndex = index);
    _scrollarSeletorParaDia(index);
  }

  void _scrollarSeletorParaDia(int index) {
    final offset =
        _seletorPadding + index * (_chipWidth + _chipSpacing) - _chipWidth;
    _seletorScroll.animateTo(
      offset.clamp(0.0, _seletorScroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _abrirFormulario(BuildContext context, DateTime dia, SemanaViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cores.fundoCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FormularioPlanejamento(
        dia: dia,
        onSalvar: (titulo) => vm.adicionarMetaManual(titulo, data: dia),
      ),
    );
  }

  void _mostrarEdicao(MetaDiaria meta, SemanaViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cores.fundoCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FormularioPlanejamento(
        dia: meta.data,
        tituloInicial: meta.titulo,
        labelBotao: 'Salvar',
        onSalvar: (novoTitulo) => vm.atualizarMetaDiaria(meta, novoTitulo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Scaffold(
      backgroundColor: cores.fundo,
      appBar: AppBar(
        backgroundColor: cores.fundo,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back_ios_rounded,
              color: cores.textoPrimario, size: 20),
        ),
        title: Row(
          children: [
            Icon(Icons.rocket_launch_rounded, color: cores.primaria, size: 20),
            const SizedBox(width: 8),
            Text(
              'Planejar semana',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: cores.textoPrimario,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _SeletorDias(
            dias: _diasDaSemana,
            diaAtualIndex: _diaAtualIndex,
            scrollController: _seletorScroll,
            onTap: _irParaDia,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Consumer<SemanaViewModel>(
              builder: (context, vm, _) {
                return PageView.builder(
                  controller: _pageController,
                  onPageChanged: _aoMudarPagina,
                  itemCount: _diasDaSemana.length,
                  itemBuilder: (context, index) {
                    final dia = _diasDaSemana[index];
                    final chave = _chaveDia(dia);
                    final metas = vm.metasPorDia[chave] ?? [];
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding:
                                const EdgeInsets.fromLTRB(20, 12, 20, 0),
                            child: _CardDia(
                              dia: dia,
                              metas: metas,
                              onEditar: (m) => _mostrarEdicao(m, vm),
                              onExcluir: (m) =>
                                  vm.removerMetaDiaria(m.id, data: m.data),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20, 12, 20, 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.add_rounded,
                                  size: 18, color: cores.primaria),
                              label: Text(
                                'Nova meta',
                                style: TextStyle(color: cores.primaria),
                              ),
                              onPressed: () =>
                                  _abrirFormulario(context, dia, vm),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: cores.primaria),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _chaveDia(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// ─── Bottom sheet de nova meta ───────────────────────────────────────────────

class _FormularioPlanejamento extends StatefulWidget {
  final DateTime dia;
  final void Function(String titulo) onSalvar;
  final String? tituloInicial;
  final String labelBotao;

  const _FormularioPlanejamento({
    required this.dia,
    required this.onSalvar,
    this.tituloInicial,
    this.labelBotao = 'Adicionar',
  });

  @override
  State<_FormularioPlanejamento> createState() =>
      _FormularioPlanejamentoState();
}

class _FormularioPlanejamentoState extends State<_FormularioPlanejamento> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.tituloInicial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _salvar() {
    final titulo = _controller.text.trim();
    if (titulo.isEmpty) return;
    widget.onSalvar(titulo);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final diaSemana = diaDaData(widget.dia);

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
            'Nova meta — ${diaSemana.nomeCompleto}',
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
              child: Text(widget.labelBotao),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Seletor de dias ─────────────────────────────────────────────────────────

class _SeletorDias extends StatelessWidget {
  final List<DateTime> dias;
  final int diaAtualIndex;
  final ScrollController scrollController;
  final void Function(int index) onTap;

  const _SeletorDias({
    required this.dias,
    required this.diaAtualIndex,
    required this.scrollController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();

    return SizedBox(
      height: 72,
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dias.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final dia = dias[index];
          final selecionado = index == diaAtualIndex;
          final ehHoje = mesmoDia(dia, hoje);
          return _ChipDia(
            data: dia,
            selecionado: selecionado,
            ehHoje: ehHoje,
            onTap: () => onTap(index),
          );
        },
      ),
    );
  }
}

class _ChipDia extends StatelessWidget {
  final DateTime data;
  final bool selecionado;
  final bool ehHoje;
  final VoidCallback onTap;

  const _ChipDia({
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
    Color corBorda;

    if (selecionado) {
      fundo = cores.diaSelecionado;
      corTexto = Colors.white;
      corBorda = cores.diaSelecionado;
    } else if (ehHoje) {
      fundo = cores.diaAtual;
      corTexto = cores.primaria;
      corBorda = cores.primaria;
    } else {
      fundo = cores.fundoCard;
      corTexto = cores.textoPrimario;
      corBorda = cores.divisor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        decoration: BoxDecoration(
          color: fundo,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: corBorda),
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

// ─── Card do dia ─────────────────────────────────────────────────────────────

class _CardDia extends StatelessWidget {
  final DateTime dia;
  final List<MetaDiaria> metas;
  final void Function(MetaDiaria meta) onEditar;
  final void Function(MetaDiaria meta) onExcluir;

  const _CardDia({
    required this.dia,
    required this.metas,
    required this.onEditar,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final diaSemana = diaDaData(dia);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cores.fundoCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                diaSemana.nomeCompleto,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: cores.textoPrimario,
                ),
              ),
              const Spacer(),
              Text(
                '${dia.day} ${_nomeMes(dia.month)}',
                style: TextStyle(fontSize: 13, color: cores.textoSecundario),
              ),
            ],
          ),
          Divider(height: 28, color: cores.divisor),
          if (metas.isEmpty)
            Text(
              'Nenhuma meta para este dia.',
              style: TextStyle(
                fontSize: 13,
                color: cores.textoSecundario,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            ...metas.map(
              (m) => _ItemMeta(
                meta: m,
                onEditar: () => onEditar(m),
                onExcluir: () => onExcluir(m),
              ),
            ),
        ],
      ),
    );
  }

  String _nomeMes(int mes) {
    const meses = [
      '', 'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
      'jul', 'ago', 'set', 'out', 'nov', 'dez',
    ];
    return meses[mes];
  }
}

// ─── Item de meta ─────────────────────────────────────────────────────────────

class _ItemMeta extends StatelessWidget {
  final MetaDiaria meta;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  const _ItemMeta({
    required this.meta,
    required this.onEditar,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: meta.concluida
                  ? cores.metaConcluida
                  : cores.primaria.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              meta.titulo,
              style: TextStyle(
                fontSize: 14,
                color: meta.concluida
                    ? cores.textoSecundario
                    : cores.textoPrimario,
                decoration:
                    meta.concluida ? TextDecoration.lineThrough : null,
                decorationColor: cores.textoSecundario,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onEditar,
            child:
                Icon(Icons.edit_outlined, size: 16, color: cores.textoSecundario),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onExcluir,
            child: Icon(Icons.delete_outline_rounded,
                size: 16, color: cores.textoSecundario),
          ),
        ],
      ),
    );
  }
}
