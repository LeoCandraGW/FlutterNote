import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Todo {
  static final Todo instance = Todo._init();

  static Database? _database;

  Todo._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getApplicationCacheDirectory();
    final path = join(dbPath.path, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        createdAt TEXT NOT NULL,
        finishedAt TEXT,
        expiredAt TEXT
      )
''');
  }

  Future<void> insertTodo() async {
    final db = await instance.database;
    await db.insert('todo', {
      'title': 'title',
      'description': 'description',
      'createdAt': DateTime.now().toIso8601String(),
      'finishedAt': null,
      'expiredAt': null,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> newtodo() async {
    final db = await instance.database;
    final result = await db.query(
      'todo',
      columns: ['id'],
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      throw Exception('No todo items found');
    }
  }

  Future<Map<String, dynamic>> fetchDetailTodo(int id) async {
    final db = await instance.database;

    final result = await db.query('todo', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      throw Exception('Todo with id $id not found');
    }
  }

  Future<void> updateTodo(
    int id,
    String title,
    String description,
    String expiredAt,
  ) async {
    final db = await instance.database;
    await db.update(
      'todo',
      {'title': title, 'description': description, 'expiredAt': expiredAt},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateFinished(int id) async {
    final db = await instance.database;

    await db.update(
      'todo',
      {'finishedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateExpired(int id, String expiredAt) async {
    final db = await instance.database;

    await db.update(
      'todo',
      {'expiredAt': expiredAt},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> fetchActiveTodo() async {
    final db = await instance.database;

    final today = DateTime.now().toIso8601String();

    return await db.query(
      'todo',
      where: 'finishedAt IS NULL AND (expiredAt IS NULL OR expiredAt > ?)',
      whereArgs: [today],
    );
  }

  Future<List<Map<String, dynamic>>> fetchFinishedTodo() async {
    final db = await instance.database;

    return await db.query(
      'todo',
      where: 'finishedAt IS NOT NULL',
      orderBy: 'createdAt DESC',
    );
  }

  Future<List<Map<String, dynamic>>> fetchExpiredTodo() async {
    final db = await instance.database;

    final today = DateTime.now().toIso8601String();

    return await db.query(
      'todo',
      where: 'expiredAt IS NOT NULL AND expiredAt < ?',
      whereArgs: [today],
      orderBy: 'createdAt DESC',
    );
  }

  Future<void> deleteTodo(int id) async {
    final db = await instance.database;

    await db.delete('todo', where: 'id = ?', whereArgs: [id]);
  }
}
