import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/cores_app.dart';
import '../../core/theme/tema_provider.dart';
import '../metas_recorrentes/metas_recorrentes_page.dart';

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Scaffold(
      backgroundColor: cores.fundo,
      appBar: AppBar(
        backgroundColor: cores.fundo,
        elevation: 0,
        title: Text(
          'Configurações',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: cores.textoPrimario,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ItemNavegacao(
              icone: Icons.repeat_rounded,
              titulo: 'Metas recorrentes',
              subtitulo: 'Gerencie metas que se repetem na semana',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MetasRecorrentesPage(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _ItemToggleTema(),
          ],
        ),
      ),
    );
  }
}

class _ItemNavegacao extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _ItemNavegacao({
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cores.fundoCard,
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
                color: cores.primariaSuave,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: cores.primaria, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: cores.textoPrimario,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: TextStyle(fontSize: 12, color: cores.textoSecundario),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: cores.textoSecundario,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemToggleTema extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final tema = context.watch<TemaProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cores.fundoCard,
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
              color: cores.primariaSuave,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              tema.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: cores.primaria,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aparência',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cores.textoPrimario,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tema.isDark ? 'Modo escuro ativado' : 'Modo claro ativado',
                  style: TextStyle(fontSize: 12, color: cores.textoSecundario),
                ),
              ],
            ),
          ),
          Switch(
            value: tema.isDark,
            onChanged: (_) => tema.alternar(),
            activeThumbColor: cores.primaria,
            activeTrackColor: cores.primariaSuave,
          ),
        ],
      ),
    );
  }
}
