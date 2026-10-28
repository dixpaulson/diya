import 'gita_data.dart';
import 'hanuman_data.dart';

// A short, shareable piece drawn from the texts.
class DailyItem {
  final String native;
  final String transliteration;
  final String quote; // the short English line to feature
  final String source;
  const DailyItem({
    required this.native,
    required this.transliteration,
    required this.quote,
    required this.source,
  });
}

// The pool of shareable verses: every Gita verse we've translated, plus
// the Hanuman Chalisa. Grows automatically as we translate more.
List<DailyItem> _buildPool() {
  final pool = <DailyItem>[];
  for (final v in gitaVerses) {
    if (v.meaning.isEmpty) continue;
    pool.add(DailyItem(
      native: v.sanskrit,
      transliteration: v.transliteration,
      quote: v.inShort.isNotEmpty ? v.inShort : v.meaning,
      source: 'Bhagavad Gita ${v.chapter}.${v.verse}',
    ));
  }
  for (final v in hanumanChalisa) {
    pool.add(DailyItem(
      native: v.native,
      transliteration: v.transliteration,
      quote: v.meaning,
      source: 'Hanuman Chalisa',
    ));
  }
  return pool;
}

final List<DailyItem> dailyPool = _buildPool();

// The same verse for the whole day; changes each day. (Deterministic by date,
// so it's identical across everyone's phones — nice for "did you see today's?")
DailyItem verseOfTheDay([DateTime? when]) {
  final now = (when ?? DateTime.now()).toUtc();
  final dayNumber = now.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  return dailyPool[dayNumber % dailyPool.length];
}
