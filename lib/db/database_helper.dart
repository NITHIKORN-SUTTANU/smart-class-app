import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/checkin_record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'smart_class.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE checkin (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentId TEXT,
            checkInTime TEXT,
            gpsLat REAL,
            gpsLng REAL,
            qrCodeData TEXT,
            previousTopic TEXT,
            expectedTopic TEXT,
            moodBefore INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE checkout (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentId TEXT,
            checkOutTime TEXT,
            gpsLat REAL,
            gpsLng REAL,
            qrCodeData TEXT,
            whatLearned TEXT,
            feedback TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertCheckIn(CheckInRecord record) async {
    final db = await database;
    return db.insert('checkin', record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertCheckOut(CheckOutRecord record) async {
    final db = await database;
    return db.insert('checkout', record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CheckInRecord>> getAllCheckIns() async {
    final db = await database;
    final rows = await db.query('checkin', orderBy: 'id DESC');
    return rows.map(CheckInRecord.fromMap).toList();
  }

  Future<List<CheckOutRecord>> getAllCheckOuts() async {
    final db = await database;
    final rows = await db.query('checkout', orderBy: 'id DESC');
    return rows.map(CheckOutRecord.fromMap).toList();
  }
}
