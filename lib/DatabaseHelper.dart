import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if(_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(),'my_database.db');
    return await openDatabase(
        path,
        version: 1,
        onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db,int version) async {
    await db.execute("CREATE TABLE items("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "password TEXT)"
    );
  }

  Future<void> insertItem(Item item) async {
    Database db = await database;
    await db.insert(
        'items',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteItem(int id) async {
    Database db = await database;
    await db.delete(
        'items',
        where: 'id = ?',
        whereArgs: [id],
    );
  }

  Future<void> updateItem(Item item) async {
    Database db = await database;
    await db.update(
        'items',
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
    );
  }

  Future<List<Item>> getAllItems() async {
    Database db = await database;
    final List<Map<String,dynamic>> lst = await db.query('items');

    return lst.map((map) => Item.fromMap(map)).toList();
  }

  Future<List<Item>> getItem(String name) async {
    Database db = await database;
    final List<Map<String,dynamic>> lst = await db.query(
      'items',
      where: 'name = ?', //模糊搜尋 'name LIKE ?',
      whereArgs: [name], //模糊搜尋 ['$%name%'],
    );

    //.map() 遍歷lst，mp代表lst的一個項目
    return lst.map((mp) => Item.fromMap(mp)).toList();
  }

  Future<void> deleteAllItems() async {
    Database db = await database;
    await db.delete('items');
  }
}

class Item {
  int? id;
  String name,password;

  //Item(this.name, this.password);
  Item({this.id, required this.name, required this.password});

  Map<String,dynamic> toMap() {
    return {
      if(id != null) 'id': id,
      'name': name,
      'password': password,
    };
  }

  factory Item.fromMap(Map<String,dynamic> mp) {
    return Item(
      id: mp['id'],
      name: mp['name'],
      password: mp['password'],
    );
  }
}