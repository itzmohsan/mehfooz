import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/pointycastle.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _authBox = 'auth_data';
  static const String _pinKey = 'user_pin_hash';
  static const String _saltKey = 'auth_salt';
  static const String _isSetupKey = 'auth_setup';

  Future<void> initialize() async {
    await Hive.openBox(_authBox);
  }

  Future<bool> isAuthSetup() async {
    final box = Hive.box(_authBox);
    return box.get(_isSetupKey, defaultValue: false);
  }

  Future<void> setupAuth(String pin) async {
    final box = Hive.box(_authBox);
    final salt = _generateSalt();
    final pinHash = _hashPin(pin, salt);
    
    await box.putAll({
      _pinKey: pinHash,
      _saltKey: salt,
      _isSetupKey: true,
    });
  }

  Future<bool> verifyPin(String pin) async {
    final box = Hive.box(_authBox);
    final storedHash = box.get(_pinKey);
    final salt = box.get(_saltKey);
    
    if (storedHash == null || salt == null) return false;
    
    final inputHash = _hashPin(pin, salt);
    return storedHash == inputHash;
  }

  String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(saltBytes);
  }

  String _hashPin(String pin, String salt) {
    final bytes = utf8.encode(pin + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> clearAuth() async {
    final box = Hive.box(_authBox);
    await box.clear();
  }
}

class EncryptionService {
  static String encryptData(String data, String pin) {
    // In production, use proper AES encryption with PointyCastle
    // This is a simplified version for demo
    final key = _deriveKey(pin);
    final bytes = utf8.encode(data);
    final encrypted = _xorEncrypt(bytes, key);
    return base64Url.encode(encrypted);
  }

  static String decryptData(String encryptedData, String pin) {
    try {
      final key = _deriveKey(pin);
      final encryptedBytes = base64Url.decode(encryptedData);
      final decrypted = _xorEncrypt(encryptedBytes, key);
      return utf8.decode(decrypted);
    } catch (e) {
      throw Exception('Decryption failed');
    }
  }

  static List<int> _deriveKey(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.bytes.sublist(0, 16); // 128-bit key
  }

  static List<int> _xorEncrypt(List<int> data, List<int> key) {
    return data.asMap().entries.map((entry) {
      return entry.value ^ key[entry.key % key.length];
    }).toList();
  }
}
