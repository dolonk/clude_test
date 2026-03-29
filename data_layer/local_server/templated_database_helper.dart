import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'models/local_widget_container_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'models/local_main_widget_container_model.dart';

class TemplateDatabaseHelper {
  static Database? _database;
  static const _dbName = 'MainContainerDB.db';
  static const _dbVersion = 2;

  /// Production-Ready: deleteOld is false by default to preserve data.
  static Future<void> initOpenDatabase({bool deleteOld = false}) async {
    try {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      final dbPath = join(await getDatabasesPath(), _dbName);

      // Check if file exists and delete if requested (Use with caution!)
      if (deleteOld && await File(dbPath).exists()) {
        await deleteDatabase(dbPath);
        debugPrint('⚠️ Old database deleted intentionally: $_dbName');
      }
    } catch (e, s) {
      debugPrint('Error initializing database: $e\n$s');
    }
  }

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), _dbName),
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );

    return _database!;
  }

  /// Handle database upgrades
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute("ALTER TABLE WidgetContainerTable ADD COLUMN widgetType TEXT NOT NULL DEFAULT 'Text'");
        debugPrint('Migrated WidgetContainerTable: Added widgetType column');
      } catch (e) {
        debugPrint('Migration error (widgetType): $e');
      }
    }
  }

  /// Table creation
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE MainContainerTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        containerName TEXT NOT NULL,
        containerHeight INTEGER NOT NULL,
        containerWidth INTEGER NOT NULL,
        containerImageBitmapData BLOB,
        subCategories TEXT,
        printerType TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE WidgetContainerTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mainContainerId INTEGER NOT NULL,

        widgetType TEXT NOT NULL, 

        -- Primary
        contentData TEXT NOT NULL,
        offsetDx REAL NOT NULL,
        offsetDy REAL NOT NULL,
        width REAL NOT NULL,
        height REAL,
        rotation REAL,

        -- Text style
        isBold INTEGER DEFAULT 0,
        isUnderline INTEGER DEFAULT 0,
        isItalic INTEGER DEFAULT 0,
        isTextStrikeThrough INTEGER DEFAULT 0,
        fontSize REAL,
        textAlignment TEXT, 
        fontFamily TEXT,

         -- text
        checkTextIdentifyWidget TEXT,

        -- Barcode variables
        barEncodingType TEXT,

        -- Table
        rowCount INTEGER,
        columnCount INTEGER,
        tablesCells TEXT,
        tablesRowHeights TEXT,
        tablesColumnWidths TEXT,

        -- Emoji variables
        selectedEmojiIcons BLOB,

        -- serial number
        prefix TEXT,
        suffix TEXT,

        -- Shape variables
        shapeTypes TEXT,
        isRectangale INTEGER DEFAULT 0,
        isRoundRectangale INTEGER DEFAULT 0,
        isCircularFixed INTEGER DEFAULT 0,
        isCircularNotFixed INTEGER DEFAULT 0,
        widgetLineWidth REAL,
        isFixedFigureSize INTEGER DEFAULT 0,
        trueShapeWidth REAL,
        trueShapeHeight REAL,
        
        FOREIGN KEY(mainContainerId) REFERENCES MainContainerTable(id) ON DELETE CASCADE
      );
    ''');
    debugPrint("Tables Created Successfully");
  }

  /// CRUD for MainContainerTable
  static Future<int> insertMainContainer(MainContainerModelClass model) async {
    final db = await database;
    return await db.insert('MainContainerTable', model.toMap());
  }

  static Future<List<MainContainerModelClass>> getAllMainContainers() async {
    final db = await database;
    final result = await db.query('MainContainerTable');
    return result.map((e) => MainContainerModelClass.fromMap(e)).toList();
  }

  static Future<MainContainerModelClass?> getMainContainerById(int id) async {
    final db = await database;
    final result = await db.query('MainContainerTable', where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty ? MainContainerModelClass.fromMap(result.first) : null;
  }

  static Future<int> updateMainContainer(MainContainerModelClass model) async {
    final db = await database;
    return await db.update('MainContainerTable', model.toMap(), where: 'id = ?', whereArgs: [model.id]);
  }

  static Future<int> deleteMainContainer(int id) async {
    final db = await database;
    return await db.delete('MainContainerTable', where: 'id = ?', whereArgs: [id]);
  }

  /// CRUD for WidgetContainerTable
  static Future<int> insertWidgetContainer(WidgetContainerModelClass model) async {
    final db = await database;
    return await db.insert('WidgetContainerTable', model.toMap());
  }

  static Future<List<WidgetContainerModelClass>> getWidgetContainersForMainContainer(int mainContainerId) async {
    final db = await database;
    final result = await db.query('WidgetContainerTable', where: 'mainContainerId = ?', whereArgs: [mainContainerId]);
    return result.map((e) => WidgetContainerModelClass.fromMap(e)).toList();
  }

  static Future<int> deleteWidgetContainer(int id) async {
    final db = await database;
    return await db.delete('WidgetContainerTable', where: 'id = ?', whereArgs: [id]);
  }

  static Future<bool> doesContainerNameExist(String containerName) async {
    final db = await database;
    final result = await db.query(
      'MainContainerTable',
      where: 'containerName = ?',
      whereArgs: [containerName],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      debugPrint('Database closed');
      _database = null;
    }
  }
}
