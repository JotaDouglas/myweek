import 'package:flutter/material.dart';

import '../../core/theme/cores_app.dart';
import '../metas_recorrentes/metas_recorrentes_page.dart';

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.fundo,
      appBar: AppBar(
        backgroundColor: CoresApp.fundo,
        elevation: 0,
        title: const Text(
          'Configurações',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: CoresApp.textoPrimario,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ItemConfiguracao(
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
          ],
        ),
      ),
    );
  }
}

class _ItemConfiguracao extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _ItemConfiguracao({
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              child: Icon(icone, color: CoresApp.primaria, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: CoresApp.textoPrimario,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CoresApp.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: CoresApp.textoSecundario,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
