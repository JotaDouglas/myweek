import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/cores_app.dart';
import '../data/database/database_service.dart';
import '../data/repositories/meta_repository_sqlite.dart';
import '../viewmodels/metas_recorrentes_viewmodel.dart';
import '../viewmodels/semana_viewmodel.dart';
import '../views/navegacao/navegacao_page.dart';

class MyWeekApp extends StatelessWidget {
  const MyWeekApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MetaRepositorySqlite(DatabaseService.instance);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SemanaViewModel(repository),
        ),
        ChangeNotifierProvider(
          create: (_) => MetasRecorrentesViewModel(repository),
        ),
      ],
      child: MaterialApp(
        title: 'My Week',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: CoresApp.primaria),
          scaffoldBackgroundColor: CoresApp.fundo,
          fontFamily: 'SF Pro Display',
          useMaterial3: true,
        ),
        home: const NavegacaoPage(),
      ),
    );
  }
}
