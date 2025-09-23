import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../models/place_model.dart';

abstract class LocalDataSource {
  Future<void> initializeDatabase();
  Future<List<PlaceModel>> getAllPlaces();
  Future<List<PlaceModel>> searchPlaces(String query);
  Future<PlaceModel?> getPlaceById(String id);
  Future<List<PlaceModel>> getPlacesByCategory(String category);
  Future<bool> toggleFavoritePlace(String placeId);
  Future<List<PlaceModel>> getFavoritePlaces();
  Future<void> insertPlace(PlaceModel place);
  Future<void> insertPlaces(List<PlaceModel> places);
}

class LocalDataSourceImpl implements LocalDataSource {
  static Database? _database;

  @override
  Future<void> initializeDatabase() async {
    if (_database != null) return;

    final databasesPath = await getDatabasesPath();
    final dbPath = path.join(databasesPath, 'unisphere_map.db');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createTables,
    );

    // Insert initial campus places data
    await _insertInitialData();
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE places (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        category TEXT NOT NULL,
        imageUrl TEXT,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        additionalInfo TEXT
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_places_category ON places(category);
    ''');

    await db.execute('''
      CREATE INDEX idx_places_favorite ON places(isFavorite);
    ''');
  }

  Future<void> _insertInitialData() async {
    final db = _database!;
    
    // Check if data already exists
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM places'),
    );
    
    if (count != null && count > 0) return;

    // Sample campus places - ใส่ข้อมูลตัวอย่างสถานที่ในมหาวิทยาลัย
    final samplePlaces = [
      PlaceModel(
        id: '1',
        name: 'ห้องสมุดกลาง',
        description: 'ห้องสมุดหลักของมหาวิทยาลัย',
        latitude: 14.8816,
        longitude: 102.0144,
        category: 'library',
      ),
      PlaceModel(
        id: '2',
        name: 'อาคารเรียนรวม 1',
        description: 'อาคารเรียนรวมหลัก คณะต่างๆ',
        latitude: 14.8820,
        longitude: 102.0150,
        category: 'building',
      ),
      PlaceModel(
        id: '3',
        name: 'โรงอาหารกลาง',
        description: 'โรงอาหารหลักของมหาวิทยาลัย',
        latitude: 14.8812,
        longitude: 102.0140,
        category: 'restaurant',
      ),
      PlaceModel(
        id: '4',
        name: 'สนามกีฬา',
        description: 'สนามกีฬาและสำนักงานกิจการนักศึกษา',
        latitude: 14.8808,
        longitude: 102.0135,
        category: 'sport',
      ),
      PlaceModel(
        id: '5',
        name: 'หอพักนักศึกษา A',
        description: 'หอพักนักศึกษาชาย',
        latitude: 14.8825,
        longitude: 102.0155,
        category: 'dormitory',
      ),
    ];

    for (final place in samplePlaces) {
      await db.insert('places', place.toJson());
    }
  }

  @override
  Future<List<PlaceModel>> getAllPlaces() async {
    if (_database == null) await initializeDatabase();
    
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query('places');
    
    return List.generate(maps.length, (i) {
      return PlaceModel.fromJson(maps[i]);
    });
  }

  @override
  Future<List<PlaceModel>> searchPlaces(String query) async {
    if (_database == null) await initializeDatabase();
    
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      'places',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    
    return List.generate(maps.length, (i) {
      return PlaceModel.fromJson(maps[i]);
    });
  }

  @override
  Future<PlaceModel?> getPlaceById(String id) async {
    if (_database == null) await initializeDatabase();
    
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      'places',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    if (maps.isNotEmpty) {
      return PlaceModel.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<List<PlaceModel>> getPlacesByCategory(String category) async {
    if (_database == null) await initializeDatabase();
    
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      'places',
      where: 'category = ?',
      whereArgs: [category],
    );
    
    return List.generate(maps.length, (i) {
      return PlaceModel.fromJson(maps[i]);
    });
  }

  @override
  Future<bool> toggleFavoritePlace(String placeId) async {
    if (_database == null) await initializeDatabase();
    
    final db = _database!;
    
    // Get current favorite status
    final List<Map<String, dynamic>> result = await db.query(
      'places',
      columns: ['isFavorite'],
      where: 'id = ?',
      whereArgs: [placeId],
      limit: 1,
    );
    
    if (result.isEmpty) return false;
    
    final currentStatus = result.first['isFavorite'] as int;
    final newStatus = currentStatus == 1 ? 0 : 1;
    
    await db.update(
      'places',
      {'isFavorite': newStatus},
      where: 'id = ?',
      whereArgs: [placeId],
    );
    
    return newStatus == 1;
  }

  @override
  Future<List<PlaceModel>> getFavoritePlaces() async {
    if (_database == null) await initializeDatabase();
    
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      'places',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    
    return List.generate(maps.length, (i) {
      return PlaceModel.fromJson(maps[i]);
    });
  }

  @override
  Future<void> insertPlace(PlaceModel place) async {
    if (_database == null) await initializeDatabase();
    
    final db = _database!;
    await db.insert(
      'places',
      place.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> insertPlaces(List<PlaceModel> places) async {
    if (_database == null) await initializeDatabase();
    
    final db = _database!;
    final batch = db.batch();
    
    for (final place in places) {
      batch.insert(
        'places',
        place.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit();
  }
}