import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/post_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('posts_database.db');
    return _database!;
  }

  Future<Database> _initDB(String dbPath) async {
    final dbFolder = await getDatabasesPath();
    final path = join(dbFolder, dbPath);

    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY,
        userId INTEGER,
        title TEXT,
        body TEXT
      )
    ''');
  }

  Future<int> insertPost(Post post) async {
    final db = await instance.database;
    return await db.insert('posts', post.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Post>> getPosts() async {
    final db = await instance.database;
    final result = await db.query('posts');
    print('Fetched from DB: ${result.length} posts');
    return result.map((json) => Post.fromJson(json)).toList();
  }

  Future<void> clearPosts() async {
    final db = await instance.database;
    await db.delete('posts');
  }
}
