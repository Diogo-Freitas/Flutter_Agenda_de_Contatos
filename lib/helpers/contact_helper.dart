import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contacts.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute('''
          CREATE TABLE $contactTable(
            $idColumn INTEGER PRIMARY KEY,
            $nameColumn TEXT,
            $emailColumn TEXT,
            $phoneColumn TEXT,
            $imgColumn TEXT
          )
        ''');
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database? dbContact = await database;
    if (dbContact != null) {
      contact.id = await dbContact.insert(
        contactTable,
        contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      throw Exception("Database not initialized");
    }
    return contact;
  }

  Future<Contact?> getContact(int id) async {
    Database? dbContact = await database;
    if (dbContact != null) {
      List<Map<String, dynamic>> maps = await dbContact.query(
        contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Contact.fromMap(maps.first);
      } else {
        return null;
      }
    } else {
      throw Exception("Database not initialized");
    }
  }

  Future<List<Contact>> getAllContacts() async {
    Database? dbContact = await database;
    if (dbContact != null) {
      List<Map<String, dynamic>> maps = await dbContact.query(contactTable);

      return maps.map((map) => Contact.fromMap(map)).toList();
    } else {
      throw Exception("Database not initialized");
    }
  }

  Future<int?> getNumber() async {
    Database? dbContact = await database;
    if (dbContact != null) {
      return Sqflite.firstIntValue(
          await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
    } else {
      throw Exception("Database not initialized");
    }
  }

  Future<int?> updateContact(Contact contact) async {
    Database? dbContact = await database;
    if (dbContact != null) {
      return await dbContact.update(contactTable, contact.toMap(),
          where: "$idColumn = ?", whereArgs: [contact.id]);
    } else {
      throw Exception("Database not initialized");
    }
  }

  Future<int?> deleteContact(int id) async {
    Database? dbContact = await database;
    if (dbContact != null) {
      return await dbContact
          .delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
    } else {
      throw Exception("Database not initialized");
    }
  }

  Future<void> close() async {
    Database? dbContact = await database;

    if (dbContact != null) {
      dbContact.close();
    } else {
      throw Exception("Database not initialized");
    }
  }
}