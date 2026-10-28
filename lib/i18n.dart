import 'package:flutter/foundation.dart';

// The languages Diya will support. English is the default and the fallback for
// any string not yet translated. Hindi is seeded now as the proof of the
// architecture; Telugu, Tamil, Gujarati, and Malayalam are framework-ready and
// get their strings + content translated (with native-speaker review) over time.
enum AppLang { english, hindi, telugu, tamil, gujarati, malayalam }

extension AppLangInfo on AppLang {
  String get code => switch (this) {
        AppLang.english => 'en',
        AppLang.hindi => 'hi',
        AppLang.telugu => 'te',
        AppLang.tamil => 'ta',
        AppLang.gujarati => 'gu',
        AppLang.malayalam => 'ml',
      };

  String get englishName => switch (this) {
        AppLang.english => 'English',
        AppLang.hindi => 'Hindi',
        AppLang.telugu => 'Telugu',
        AppLang.tamil => 'Tamil',
        AppLang.gujarati => 'Gujarati',
        AppLang.malayalam => 'Malayalam',
      };

  String get nativeName => switch (this) {
        AppLang.english => 'English',
        AppLang.hindi => 'हिन्दी',
        AppLang.telugu => 'తెలుగు',
        AppLang.tamil => 'தமிழ்',
        AppLang.gujarati => 'ગુજરાતી',
        AppLang.malayalam => 'മലയാളം',
      };
}

// The chosen UI language (persisted by Profile). The app rebuilds when this
// changes because the root is wrapped in a ValueListenableBuilder on it.
final currentLang = ValueNotifier<AppLang>(AppLang.english);

AppLang appLangFromCode(String? code) =>
    AppLang.values.firstWhere((l) => l.code == code, orElse: () => AppLang.english);

// UI strings. English is complete; other languages fall back to English for any
// missing key, so partial translations are safe. Content (mantra meanings, Gita,
// etc.) is localized separately as it gets translated.
const Map<AppLang, Map<String, String>> _strings = {
  AppLang.english: {
    'tab_home': 'Home',
    'tab_prayers': 'Prayers',
    'tab_playlists': 'Playlists',
    'tab_vidya': 'Vidya',
    'tab_panchang': 'Panchang',
    'good_morning': 'Good morning',
    'verse_of_day': 'Verse of the day',
    'explore_deity': 'Explore by deity',
    'todays_prayer': 'Today’s prayer',
    'how_feeling': 'How are you feeling?',
    'for_your_day': 'For your day',
    'prayers_title': 'Prayers',
    'find_mantra_for': 'Find a mantra for…',
    'all_mantras': 'All mantras',
    'vidya_title': 'Vidya',
    'vidya_subtitle': 'Sacred texts and stories',
    'panchang_title': 'Panchang',
    'saved': 'Saved',
    'language': 'Language',
  },
  AppLang.hindi: {
    'tab_home': 'होम',
    'tab_prayers': 'मंत्र',
    'tab_playlists': 'प्लेलिस्ट',
    'tab_vidya': 'विद्या',
    'tab_panchang': 'पंचांग',
    'good_morning': 'सुप्रभात',
    'verse_of_day': 'आज का श्लोक',
    'explore_deity': 'देवता के अनुसार',
    'todays_prayer': 'आज का मंत्र',
    'how_feeling': 'आप कैसा महसूस कर रहे हैं?',
    'for_your_day': 'आपके दिन के लिए',
    'prayers_title': 'मंत्र',
    'find_mantra_for': 'इसके लिए मंत्र खोजें…',
    'all_mantras': 'सभी मंत्र',
    'vidya_title': 'विद्या',
    'vidya_subtitle': 'पवित्र ग्रंथ और कहानियाँ',
    'panchang_title': 'पंचांग',
    'saved': 'सहेजे गए',
    'language': 'भाषा',
  },
};

// Look up a UI string in the current language, falling back to English.
String t(String key) {
  return _strings[currentLang.value]?[key] ?? _strings[AppLang.english]?[key] ?? key;
}
