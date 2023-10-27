import 'package:shared_preferences/shared_preferences.dart';

/**
 * Manages presistence of favorite meals
 * 
 * The app will save the users favorites 
 * and loade them the next time they use the app
 */
class PersistFavorites {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _keyFavorites = 'favorites';
  List<String> favorites = [];

  //save favorit to favorit list
  Future addFavorites(String mealID) async {
    final SharedPreferences prefs = await _prefs;
    favorites.add(mealID);
    prefs.setStringList(_keyFavorites, favorites);
  }

  //remove favorit from favorit list
  Future removeFavorites(String mealID) async {
    final SharedPreferences prefs = await _prefs;
    favorites.remove(mealID);
    prefs.setStringList(_keyFavorites, favorites);
  }

  //return the favorit list 
  Future<List<String>?> getFavorites() async {
    final SharedPreferences prefs = await _prefs;
    favorites.addAll(prefs.getStringList(_keyFavorites) ?? []);
    return prefs.getStringList(_keyFavorites);
  }
}