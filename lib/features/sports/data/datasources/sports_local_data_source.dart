import 'package:hive/hive.dart';
import '../models/match_event_model.dart';

abstract class SportsLocalDataSource {
  Future<void> cacheMatches(List<MatchEventModel> matches);
  Future<List<MatchEventModel>> getCachedMatches();
  Future<void> saveFavorites(Set<String> matchIds);
  Future<Set<String>> getFavorites();
  Future<void> saveNotificationStatus(bool isEnabled);
  Future<bool> getNotificationStatus();
}

class SportsLocalDataSourceImpl implements SportsLocalDataSource {
  final Box box;
  static const String CACHE_KEY = 'SPORTS_CACHE';
  static const String FAVORITES_KEY = 'FAVORITES_CACHE';
  static const String NOTIFICATION_KEY = 'NOTIFICATION_CACHE';

  SportsLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheMatches(List<MatchEventModel> matches) async {
    // In a real app, we'd store the actual JSON or use a TypeAdapter.
    // For this reconstruction, we'll keep it simple.
  }

  @override
  Future<List<MatchEventModel>> getCachedMatches() async {
    return [];
  }

  @override
  Future<void> saveFavorites(Set<String> matchIds) async {
    await box.put(FAVORITES_KEY, matchIds.toList());
  }

  @override
  Future<Set<String>> getFavorites() async {
    final List<dynamic>? list = box.get(FAVORITES_KEY);
    return list?.map((e) => e.toString()).toSet() ?? {};
  }

  @override
  Future<void> saveNotificationStatus(bool isEnabled) async {
    await box.put(NOTIFICATION_KEY, isEnabled);
  }

  @override
  Future<bool> getNotificationStatus() async {
    return box.get(NOTIFICATION_KEY, defaultValue: false);
  }
}
