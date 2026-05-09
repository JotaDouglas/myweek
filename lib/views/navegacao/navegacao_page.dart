import 'package:flutter/material.dart';

import '../../core/theme/cores_app.dart';
import '../configuracoes/configuracoes_page.dart';
import '../semana/semana_page.dart';
import '../tela_inicial/tela_inicial_page.dart';

class NavegacaoPage extends StatefulWidget {
  const NavegacaoPage({super.key});

  @override
  State<NavegacaoPage> createState() => _NavegacaoPageState();
}

class _NavegacaoPageState extends State<NavegacaoPage> {
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Scaffold(
      body: IndexedStack(
        index: _indiceAtual,
        children: const [
          TelaInicialPage(),
          SemanaPage(),
          ConfiguracoesPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: cores.fundoCard,
        indicatorColor: cores.primariaSuave,
        selectedIndex: _indiceAtual,
        onDestinationSelected: (indice) =>
            setState(() => _indiceAtual = indice),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: cores.primaria),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt_rounded, color: cores.primaria),
            label: 'Metas',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded, color: cores.primaria),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
