import 'package:flutter/material.dart';

import 'app/my_week_app.dart';
import 'data/database/database_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.db;
  await NotificationService.instance.initialize();
  await NotificationService.instance.solicitarPermissao();
  if (await NotificationService.instance.notificacoesHabilitadas) {
    await NotificationService.instance.agendarNotificacoesDiarias();
  }
  runApp(const MyWeekApp());
}
