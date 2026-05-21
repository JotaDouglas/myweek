import 'package:flutter/material.dart';

import 'app/my_week_app.dart';
import 'data/database/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.db;
  runApp(const MyWeekApp());
}
