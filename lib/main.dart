import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sqlite/helper/data.dart';

import 'app.dart';
import 'controller/data_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.dbHelper.initDb();
  runApp(
    ChangeNotifierProvider(
      create: (_) => DbController(),
      child: const MyApp(),
    ),
  );
}
