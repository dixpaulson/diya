import 'package:shared_preferences/shared_preferences.dart';
import 'i18n.dart';
import 'state.dart';

// Saves and restores the user's details on the device, so the app remembers
// them between visits. Call Profile.init() once when the app starts.
class Profile {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // Restore the chosen deity into the reactive notifier used across the app.
    favouriteDeity.value = _prefs.getString('deity');

    // Whenever the deity changes anywhere, save it automatically.
    favouriteDeity.addListener(() {
      final v = favouriteDeity.value;
      if (v == null) {
        _prefs.remove('deity');
      } else {
        _prefs.setString('deity', v);
      }
    });

    favorites.value = (_prefs.getStringList('favorites') ?? const <String>[]).toSet();

    selectedCityName.value = _prefs.getString('city');
    selectedCityName.addListener(() {
      final v = selectedCityName.value;
      if (v == null) {
        _prefs.remove('city');
      } else {
        _prefs.setString('city', v);
      }
    });

    currentLang.value = appLangFromCode(_prefs.getString('lang'));
    currentLang.addListener(() => _prefs.setString('lang', currentLang.value.code));

    await _updateStreak();
  }

  static String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

  // Bumps the streak once per day: +1 if the last open was yesterday,
  // reset to 1 otherwise, unchanged if already opened today.
  static Future<void> _updateStreak() async {
    final now = DateTime.now();
    final today = _dateKey(now);
    final last = _prefs.getString('lastOpen');
    int streak = _prefs.getInt('streak') ?? 0;
    if (last != today) {
      final yesterday = _dateKey(now.subtract(const Duration(days: 1)));
      streak = (last == yesterday) ? streak + 1 : 1;
      await _prefs.setString('lastOpen', today);
      await _prefs.setInt('streak', streak);
    }
    streakCount.value = streak;
  }

  static Future<void> toggleFavorite(String id) async {
    final set = Set<String>.from(favorites.value);
    if (!set.add(id)) set.remove(id); // add() returns false if already present
    favorites.value = set;
    await _prefs.setStringList('favorites', set.toList());
  }

  static bool get onboarded => _prefs.getBool('onboarded') ?? false;

  static String? get birthDate => _prefs.getString('birthDate');
  static String? get birthTime => _prefs.getString('birthTime');
  static String? get birthPlace => _prefs.getString('birthPlace');

  // Called at the end of the welcome flow.
  static Future<void> finishOnboarding({
    String? birthDate,
    String? birthTime,
    String? birthPlace,
  }) async {
    if (birthDate != null) await _prefs.setString('birthDate', birthDate);
    if (birthTime != null) await _prefs.setString('birthTime', birthTime);
    if (birthPlace != null && birthPlace.isNotEmpty) {
      await _prefs.setString('birthPlace', birthPlace);
    }
    await _prefs.setBool('onboarded', true);
  }
}
