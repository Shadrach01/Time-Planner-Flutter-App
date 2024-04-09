import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

class AppDatabase {
  // The oly available instance of this AppDatabase class
  // is stored in this private field
  static final AppDatabase _singleton = AppDatabase._();

  // This instance get-only property is the only way for other classes to access
  // the single AppDatabase object.
  static AppDatabase get instance => _singleton;

  // Used for transforming synchronous code into asynchronous code.
  Completer<Database>? _dbOpencompleter;

  // Private constructor that can be used to create new instances
  // only from within this AppDatabase class itself
  AppDatabase._();

  /* Get the pbulic version of 
  the database that will be accessible by the public
  */
  Future<Database> get database async {
    if (_dbOpencompleter == null) {
      _dbOpencompleter = Completer();
      /*
        Calling _openDatabase will also complete the completer
        with database instance
      */
      _openDatabase();
    }
    // If database is already opened, return immediately
    // Otherwise, wait until Complete() is called on the completer with database instance
    return _dbOpencompleter!.future;
  }

  Future _openDatabase() async {
    // Get platform-specific dir where the data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();

    //Path with the form: /platform-specific-directory/time_planner.db
    final dbPath = join(appDocumentDir.path, 'time_planner.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpencompleter!.complete(database);
  }
}
