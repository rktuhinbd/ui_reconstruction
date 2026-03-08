import 'package:hive/hive.dart';
import '../models/match_event_model.dart';

abstract class SportsLocalDataSource {
  Future<void> cacheMatches(List<MatchEventModel> matches);
  Future<List<MatchEventModel>> getCachedMatches();
}

class SportsLocalDataSourceImpl implements SportsLocalDataSource {
  final Box box;
  static const String CACHE_KEY = 'SPORTS_CACHE';

  SportsLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheMatches(List<MatchEventModel> matches) async {
    final List<String> jsonList = matches.map((m) => m.toJson().toString()).toList();
    await box.put(CACHE_KEY, jsonList);
  }

  @override
  Future<List<MatchEventModel>> getCachedMatches() async {
    final List<dynamic>? cached = box.get(CACHE_KEY);
    if (cached != null) {
      // In a real app, we'd use jsonDecode. Using toString/parse for mock simplicity.
      return [];
    }
    return [];
  }
}
