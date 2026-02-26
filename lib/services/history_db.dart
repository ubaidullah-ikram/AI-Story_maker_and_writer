import 'package:ai_story_writer/model/story_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('stories.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE stories (
        id $idType,
        title $textType,
        description $textType,
        category $textType,
        createdAt $textType
      )
    ''');
  }

  // CREATE - Insert story
  Future<int> insertStory(StoryModel story) async {
    final db = await database;
    return await db.insert('stories', story.toMap());
  }

  // READ - Get all stories
  Future<List<StoryModel>> getAllStories() async {
    final db = await database;
    final result = await db.query(
      'stories',
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => StoryModel.fromMap(map)).toList();
  }

  // READ - Get stories by category
  Future<List<StoryModel>> getStoriesByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'stories',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => StoryModel.fromMap(map)).toList();
  }

  // READ - Get single story
  Future<StoryModel?> getStory(int id) async {
    final db = await database;
    final maps = await db.query(
      'stories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return StoryModel.fromMap(maps.first);
    }
    return null;
  }

  // UPDATE - Update story
  Future<int> updateStory(StoryModel story) async {
    final db = await database;
    return db.update(
      'stories',
      story.toMap(),
      where: 'id = ?',
      whereArgs: [story.id],
    );
  }

  // DELETE - Delete story
  Future<int> deleteStory(int id) async {
    final db = await database;
    return await db.delete(
      'stories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete all stories
  Future<int> deleteAllStories() async {
    final db = await database;
    return await db.delete('stories');
  }

  // Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}