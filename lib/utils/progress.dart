import 'package:shared_preferences/shared_preferences.dart';

class ProgressManager {
  static const _unlockedLevelKeyPrefix = 'unlocked_level_';
  static const _pointsKeyPrefix = 'points_';


  static Future<void> addCategoryPoints(String categoryId, int points) async 
  {
    final prefs = await SharedPreferences.getInstance();
    final current = await getCategoryPoints(categoryId);
    await prefs.setInt('$_pointsKeyPrefix$categoryId', current + points);
  }

 static Future<int> getCategoryPoints(String categoryId) async 
 {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_pointsKeyPrefix$categoryId') ?? 0;
  }

  static Future<void> resetCategoryPoints(String categoryId) async
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_pointsKeyPrefix$categoryId');
  }

   static Future<void> setCategoryPoints(String categoryId, int points) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_pointsKeyPrefix$categoryId', points);
  }

  static Future<void> deductPowerUpCost(
    String categoryId, 
    int cost
  ) async {
    final current = await getCategoryPoints(categoryId);
    await setCategoryPoints(categoryId, current - cost);
  }

  // Save unlocked level for a category by id
  static Future<void> setUnlockedLevel(String categoryId, int level) async
 {
    final prefs = await SharedPreferences.getInstance();
    final current = await getUnlockedLevel(categoryId);
    if (level > current) {
      await prefs.setInt('$_unlockedLevelKeyPrefix$categoryId', level);
    }
  }

  // Get unlocked level for a category
  static Future<int> getUnlockedLevel(String categoryId) async 
 {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_unlockedLevelKeyPrefix$categoryId') ?? 1;
  }

}
