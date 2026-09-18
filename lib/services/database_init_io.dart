import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void initLocalDatabase() {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
