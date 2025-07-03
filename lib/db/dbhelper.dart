import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "expenses.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        category TEXT,
        type TEXT,
        description TEXT,
        amount REAL,
        image TEXT
      )
    ''');
  }

  // Insert expense
  Future<int> insertExpense(Map<String, dynamic> expense) async {
    final db = await database;
    return await db.insert("expenses", expense);
  }

  // Get all expenses
  Future<List<Map<String, dynamic>>> getAllExpenses() async {
    final db = await database;
    return await db.query("expenses", orderBy: "date DESC");
  }

  // Get single expense by ID
  Future<Map<String, dynamic>?> getExpenseById(int id) async {
    final db = await database;
    final result =
    await db.query("expenses", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Update expense
  Future<int> updateExpense(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      "expenses",
      data,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Delete one expense
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete("expenses", where: "id = ?", whereArgs: [id]);
  }

  // Delete all expenses
  Future<int> deleteAllExpenses(int id) async {
    final db = await database;
    return await db.delete("expenses");
  }

  // Count total expenses
  Future<int> getExpenseCount() async {
    final db = await database;
    final result = await db.rawQuery("SELECT COUNT(*) FROM expenses");
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
