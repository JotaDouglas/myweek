import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/cores_app.dart';
import '../data/repositories/meta_repository_memoria.dart';
import '../viewmodels/metas_recorrentes_viewmodel.dart';
import '../viewmodels/semana_viewmodel.dart';
import '../views/semana/semana_page.dart';

class MyWeekApp extends StatelessWidget {
  const MyWeekApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MetaRepositoryMemoria();

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
        home: const SemanaPage(),
      ),
    );
  }
}
