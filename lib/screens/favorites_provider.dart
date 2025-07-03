import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesProvider with ChangeNotifier {
  List<FavoriteItem> _favorites = [];

  List<FavoriteItem> get favorites => _favorites;

  bool isFavorite(String title) {
    return _favorites.any((item) => item.title == title);
  }

  Future<void> toggleFavorite(FavoriteItem item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    final key = 'favorites_${user.uid}';

    if (isFavorite(item.title)) {
      _favorites.removeWhere((f) => f.title == item.title);
    } else {
      _favorites.add(item);
    }

    await prefs.setString(key, jsonEncode(_favorites.map((e) => e.toMap()).toList()));
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    final key = 'favorites_${user.uid}';
    final jsonString = prefs.getString(key);

    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      _favorites = decoded.map((e) => FavoriteItem.fromMap(e)).toList();
    } else {
      _favorites = [];
    }

    notifyListeners();
  }
}
