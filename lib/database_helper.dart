// database_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;
  static final _lock = Lock();

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }

    return await _lock.synchronized(() async {
      if (_db == null) {
        _db = await initDb();
      }
      return _db!;
    });
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'your_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            email TEXT,
            password TEXT,
            birth_date TEXT,
            gender TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE playlists (
            id INTEGER PRIMARY KEY,
            name TEXT,
            cover_path TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      Database dbClient = await db;
      return await dbClient.insert('users', user);
    } catch (e) {
      print('Error inserting user: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      Database dbClient = await db;
      return await dbClient.query('users');
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  Future<int> insertPlaylist(String name, String coverPath) async {
    try {
      Database dbClient = await db;
      return await dbClient.insert('playlists', {'name': name, 'cover_path': coverPath});
    } catch (e) {
      print('Error inserting playlist: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getPlaylists() async {
    try {
      Database dbClient = await db;
      return await dbClient.query('playlists');
    } catch (e) {
      print('Error getting playlists: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getPlaylistById(int id) async {
    try {
      Database dbClient = await db;
      List<Map<String, dynamic>> result = await dbClient.query('playlists', where: 'id = ?', whereArgs: [id]);
      if (result.isNotEmpty) {
        return result.first;
      } else {
        throw Exception('Playlist with ID $id not found');
      }
    } catch (e) {
      print('Error getting playlist by ID: $e');
      throw e;
    }
  }

  Future<int> updatePlaylist(int id, String name, String? coverPath) async {
    try {
      Database dbClient = await db;
      return await dbClient.update('playlists', {'name': name, 'cover_path': coverPath}, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error updating playlist: $e');
      return -1;
    }
  }

  Future<int> deletePlaylist(int id) async {
    try {
      Database dbClient = await db;
      return await dbClient.delete('playlists', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting playlist: $e');
      return -1;
    }
  }
}
