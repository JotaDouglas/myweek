import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/database/database_service.dart';
import '../data/repositories/meta_repository_sqlite.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  static const _prefKey = 'notificacoes_habilitadas';
  static const _channelId = 'myweek_metas';
  static const _fusoHorario = 'America/Sao_Paulo';

  static const _frasesManha = [
    'A disciplina de hoje constrói a liberdade de amanhã!',
    'Cada meta é um passo em direção aos seus sonhos!',
    'O sucesso começa com a primeira ação!',
    'Foque no progresso, não na perfeição!',
    'Hoje é o dia perfeito para conquistar mais!',
  ];

  static const _frasesTarde = [
    'Você está no caminho certo, continue assim!',
    'A perseverança é a chave do sucesso!',
    'Metade do dia, metade das conquistas!',
    'Cada tarefa concluída é uma vitória!',
    'Mantenha o ritmo, você consegue!',
  ];

  static const _frasesNoite = [
    'Que dia produtivo! Amanhã é uma nova oportunidade!',
    'Cada esforço conta — você está crescendo!',
    'Orgulhe-se do que conquistou hoje!',
    'Descanso merecido após um dia de dedicação!',
    'Você é mais forte do que imagina!',
  ];

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            'Metas Diárias',
            description: 'Lembretes sobre o progresso das suas metas diárias',
            importance: Importance.high,
          ),
        );
  }

  Future<bool> get notificacoesHabilitadas async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? true;
  }

  Future<void> setNotificacoesHabilitadas(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, valor);
    if (valor) {
      await agendarNotificacoesDiarias();
    } else {
      await cancelarTodasNotificacoes();
    }
  }

  Future<bool> solicitarPermissao() async {
    final androidGranted = await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        true;

    final iosGranted = await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true) ??
        true;

    return androidGranted && iosGranted;
  }

  Future<void> agendarNotificacoesDiarias() async {
    if (!await notificacoesHabilitadas) return;

    final repo = MetaRepositorySqlite(DatabaseService.instance);
    final metas = await repo.buscarMetasDoDia(DateTime.now());

    final total = metas.length;
    final concluidas = metas.where((m) => m.concluida).length;
    final pendentes = total - concluidas;

    await cancelarTodasNotificacoes();

    final rng = Random();
    final location = tz.getLocation(_fusoHorario);

    await _agendarNotificacao(
      id: 1,
      titulo: '☀️ Bom dia!',
      corpo: _corpoNotificacao(
        total: total,
        concluidas: concluidas,
        pendentes: pendentes,
        frase: _frasesManha[rng.nextInt(_frasesManha.length)],
        periodo: 'manha',
      ),
      hora: 8,
      minuto: 0,
      location: location,
    );

    await _agendarNotificacao(
      id: 2,
      titulo: '🌤️ Boa tarde!',
      corpo: _corpoNotificacao(
        total: total,
        concluidas: concluidas,
        pendentes: pendentes,
        frase: _frasesTarde[rng.nextInt(_frasesTarde.length)],
        periodo: 'tarde',
      ),
      hora: 12,
      minuto: 0,
      location: location,
    );

    await _agendarNotificacao(
      id: 3,
      titulo: '🌙 Boa noite!',
      corpo: _corpoNotificacao(
        total: total,
        concluidas: concluidas,
        pendentes: pendentes,
        frase: _frasesNoite[rng.nextInt(_frasesNoite.length)],
        periodo: 'noite',
      ),
      hora: 19,
      minuto: 0,
      location: location,
    );
  }

  String _corpoNotificacao({
    required int total,
    required int concluidas,
    required int pendentes,
    required String frase,
    required String periodo,
  }) {
    if (total == 0) return 'Você não tem metas para hoje. Aproveite o dia! $frase';

    if (periodo == 'manha') {
      return 'Você tem $total ${total == 1 ? 'meta' : 'metas'} para hoje. Vamos lá! $frase';
    }

    if (concluidas == total) {
      return 'Parabéns! Você concluiu todas as $total ${total == 1 ? 'meta' : 'metas'} de hoje! $frase';
    }

    return '$concluidas de $total ${total == 1 ? 'meta concluída' : 'metas concluídas'} — $pendentes ${pendentes == 1 ? 'pendente' : 'pendentes'}. $frase';
  }

  Future<void> _agendarNotificacao({
    required int id,
    required String titulo,
    required String corpo,
    required int hora,
    required int minuto,
    required tz.Location location,
  }) async {
    final agora = tz.TZDateTime.now(location);
    var horaAgendada = tz.TZDateTime(
      location,
      agora.year,
      agora.month,
      agora.day,
      hora,
      minuto,
    );

    if (horaAgendada.isBefore(agora)) {
      horaAgendada = horaAgendada.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      titulo,
      corpo,
      horaAgendada,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Metas Diárias',
          channelDescription: 'Lembretes sobre o progresso das suas metas diárias',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelarTodasNotificacoes() async {
    await _plugin.cancelAll();
  }
}
