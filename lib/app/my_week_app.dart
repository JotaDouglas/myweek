import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/tema_provider.dart';
import '../data/database/database_service.dart';
import '../data/repositories/meta_repository_sqlite.dart';
import '../services/notification_service.dart';
import '../viewmodels/metas_recorrentes_viewmodel.dart';
import '../viewmodels/semana_viewmodel.dart';
import '../views/navegacao/navegacao_page.dart';

class MyWeekApp extends StatefulWidget {
  const MyWeekApp({super.key});

  @override
  State<MyWeekApp> createState() => _MyWeekAppState();
}

class _MyWeekAppState extends State<MyWeekApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      NotificationService.instance.agendarNotificacoesDiarias();
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = MetaRepositorySqlite(DatabaseService.instance);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TemaProvider()..init()),
        ChangeNotifierProvider(create: (_) => SemanaViewModel(repository)),
        ChangeNotifierProvider(
          create: (_) => MetasRecorrentesViewModel(repository),
        ),
      ],
      child: Consumer<TemaProvider>(
        builder: (context, tema, _) => MaterialApp(
          title: 'My Week',
          debugShowCheckedModeBanner: false,
          themeMode: tema.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF4A7C59),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF7F7F5),
            fontFamily: 'SF Pro Display',
            useMaterial3: true,
            appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF5B9A6E),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF0F0F0E),
            fontFamily: 'SF Pro Display',
            useMaterial3: true,
            appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
          ),
          home: const NavegacaoPage(),
        ),
      ),
    );
  }
}
