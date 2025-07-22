import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cardkeeper.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cardholderName TEXT NOT NULL,
        bankName TEXT NOT NULL,
        cardType TEXT NOT NULL,
        cardVariant TEXT,
        cardNumber TEXT NOT NULL,
        expiryDate TEXT NOT NULL,
        cvv TEXT NOT NULL,
        cardLimit REAL NOT NULL,
        billAmount REAL DEFAULT 0.0,
        billDate TEXT,
        dueDate TEXT,
        birthDate TEXT,
        pin TEXT NOT NULL,
        ifscCode TEXT NOT NULL,
        statementPassword TEXT,
        frontImagePath TEXT,
        backImagePath TEXT,
        paymentStatus TEXT DEFAULT 'unpaid',
        lastPaymentDate TEXT,
        mobileNumber TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cardId INTEGER NOT NULL,
        reminderDate TEXT NOT NULL,
        reminderType TEXT NOT NULL,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (cardId) REFERENCES cards (id) ON DELETE CASCADE
      )
    ''');
  }

  // Card CRUD Operations
  Future<int> insertCard(Map<String, dynamic> card) async {
    final db = await database;
    
    // Encrypt sensitive data
    card['cardNumber'] = await _encryptData(card['cardNumber']);
    card['cvv'] = await _encryptData(card['cvv']);
    card['pin'] = await _encryptData(card['pin']);
    if (card['statementPassword'] != null) {
      card['statementPassword'] = await _encryptData(card['statementPassword']);
    }
    
    card['createdAt'] = DateTime.now().toIso8601String();
    card['updatedAt'] = DateTime.now().toIso8601String();
    
    return await db.insert('cards', card);
  }

  Future<List<Map<String, dynamic>>> getAllCards() async {
    final db = await database;
    final List<Map<String, dynamic>> cards = await db.query('cards');
    
    // Decrypt sensitive data
    for (var card in cards) {
      card['cardNumber'] = await _decryptData(card['cardNumber']);
      card['cvv'] = await _decryptData(card['cvv']);
      card['pin'] = await _decryptData(card['pin']);
      if (card['statementPassword'] != null) {
        card['statementPassword'] = await _decryptData(card['statementPassword']);
      }
    }
    
    return cards;
  }

  Future<Map<String, dynamic>?> getCard(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> cards = await db.query(
      'cards',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (cards.isNotEmpty) {
      var card = cards.first;
      // Decrypt sensitive data
      card['cardNumber'] = await _decryptData(card['cardNumber']);
      card['cvv'] = await _decryptData(card['cvv']);
      card['pin'] = await _decryptData(card['pin']);
      if (card['statementPassword'] != null) {
        card['statementPassword'] = await _decryptData(card['statementPassword']);
      }
      return card;
    }
    return null;
  }

  Future<int> updateCard(int id, Map<String, dynamic> card) async {
    final db = await database;
    
    // Encrypt sensitive data
    if (card.containsKey('cardNumber')) {
      card['cardNumber'] = await _encryptData(card['cardNumber']);
    }
    if (card.containsKey('cvv')) {
      card['cvv'] = await _encryptData(card['cvv']);
    }
    if (card.containsKey('pin')) {
      card['pin'] = await _encryptData(card['pin']);
    }
    if (card.containsKey('statementPassword') && card['statementPassword'] != null) {
      card['statementPassword'] = await _encryptData(card['statementPassword']);
    }
    
    card['updatedAt'] = DateTime.now().toIso8601String();
    
    return await db.update(
      'cards',
      card,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCard(int id) async {
    final db = await database;
    return await db.delete(
      'cards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Reminder CRUD Operations
  Future<int> insertReminder(Map<String, dynamic> reminder) async {
    final db = await database;
    reminder['createdAt'] = DateTime.now().toIso8601String();
    return await db.insert('reminders', reminder);
  }

  Future<List<Map<String, dynamic>>> getRemindersForCard(int cardId) async {
    final db = await database;
    return await db.query(
      'reminders',
      where: 'cardId = ? AND isActive = 1',
      whereArgs: [cardId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllActiveReminders() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT r.*, c.cardholderName, c.bankName, c.billAmount
      FROM reminders r
      JOIN cards c ON r.cardId = c.id
      WHERE r.isActive = 1
      ORDER BY r.reminderDate ASC
    ''');
  }

  Future<int> updateReminder(int id, Map<String, dynamic> reminder) async {
    final db = await database;
    return await db.update(
      'reminders',
      reminder,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Encryption/Decryption methods
  Future<String> _encryptData(String data) async {
    try {
      // Store encrypted data in secure storage
      String key = 'encrypted_${DateTime.now().millisecondsSinceEpoch}';
      await _secureStorage.write(key: key, value: data);
      return key;
    } catch (e) {
      // Fallback to base64 encoding if secure storage fails
      return base64Encode(utf8.encode(data));
    }
  }

  Future<String> _decryptData(String encryptedKey) async {
    try {
      // Try to read from secure storage first
      String? data = await _secureStorage.read(key: encryptedKey);
      if (data != null) {
        return data;
      }
      // Fallback to base64 decoding
      return utf8.decode(base64Decode(encryptedKey));
    } catch (e) {
      // Return the key itself if decryption fails (for backward compatibility)
      return encryptedKey;
    }
  }

  // Utility methods
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('reminders');
    await db.delete('cards');
    await _secureStorage.deleteAll();
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}