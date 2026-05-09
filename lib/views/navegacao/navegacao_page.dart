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
        backgroundColor: Colors.white,
        indicatorColor: CoresApp.primariaSuave,
        selectedIndex: _indiceAtual,
        onDestinationSelected: (indice) =>
            setState(() => _indiceAtual = indice),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: CoresApp.primaria),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt_rounded, color: CoresApp.primaria),
            label: 'Metas',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded, color: CoresApp.primaria),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
