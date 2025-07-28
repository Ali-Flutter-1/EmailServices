import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/email.dart';

class EmailDatabase {
  static final EmailDatabase instance = EmailDatabase._init();

  static Database? _database;

  EmailDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('emails.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE emails (
      id TEXT PRIMARY KEY,
      fromEmail TEXT,
      subject TEXT,
      intro TEXT,
      date TEXT
    )
  ''');
  }

  Future<void> insertEmail(Email email) async {
    final db = await instance.database;

    await db.insert(
      'emails',
      email.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Email>> getAllEmails() async {
    final db = await instance.database;

    final result = await db.query('emails');

    return result.map((json) => Email.fromMap(json)).toList();
  }

  Future<void> clearEmails() async {
    final db = await instance.database;
    await db.delete('emails');
  }
}
