// A curated list of major festivals with grounded dates. Festival dates follow
// the lunar calendar and can vary slightly by region, so the UI notes to verify
// locally. We add more over time; the list simply grows.
class Festival {
  final String name;
  final DateTime date;
  final String deity;
  final String blurb;
  final String howToObserve;
  const Festival({
    required this.name,
    required this.date,
    required this.deity,
    required this.blurb,
    required this.howToObserve,
  });
}

final List<Festival> festivals = [
  Festival(
    name: 'Ganesh Chaturthi',
    date: DateTime(2026, 9, 14),
    deity: 'Ganesha',
    blurb: 'The birth of Ganesha, remover of obstacles.',
    howToObserve:
        'Bring home a clay Ganesha, offer modak and durva grass, and sing his aarti. Families keep him for 1½, 5, or 10 days, then immerse the idol. At home, a small idol and daily prayer is more than enough.',
  ),
  Festival(
    name: 'Navratri begins',
    date: DateTime(2026, 10, 10),
    deity: 'Durga',
    blurb: 'Nine nights honoring the Divine Mother (to Oct 18).',
    howToObserve:
        'Light a lamp each evening; many keep a simple fast, and communities gather for garba and dandiya. A small home altar with a red cloth and a diya works beautifully — one night for each form of the Goddess.',
  ),
  Festival(
    name: 'Dussehra (Vijayadashami)',
    date: DateTime(2026, 10, 19),
    deity: 'Rama / Durga',
    blurb: 'The victory of good over evil.',
    howToObserve:
        'Celebrate Rama’s victory over Ravana and Durga over Mahishasura. Share sweets, and it is considered auspicious to begin something new — a class, an instrument, a fresh start.',
  ),
  Festival(
    name: 'Diwali',
    date: DateTime(2026, 11, 8),
    deity: 'Lakshmi',
    blurb: 'The festival of lights.',
    howToObserve:
        'Clean the home, light rows of diyas, draw a rangoli at the door, and do Lakshmi puja in the evening. Share sweets with neighbors and family. Even a few lamps and a heartfelt prayer bring the light home.',
  ),
  Festival(
    name: 'Bhai Dooj',
    date: DateTime(2026, 11, 10),
    deity: 'Yama',
    blurb: 'A day celebrating the bond of siblings.',
    howToObserve:
        'Sisters apply a tilak on their brothers’ foreheads and pray for their well-being; brothers give a gift in return. A warm day to reach out to siblings, near or far — a call counts.',
  ),
  Festival(
    name: 'Makar Sankranti',
    date: DateTime(2027, 1, 14),
    deity: 'Surya',
    blurb: 'The sun turns north; the harvest festival.',
    howToObserve:
        'Fly kites, share til-gud (sesame and jaggery) sweets, and offer gratitude to the sun at dawn. It marks longer days ahead — a good time for fresh intentions.',
  ),
];

// Festivals today or later, soonest first.
List<Festival> upcomingFestivals({int limit = 30}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final list = festivals.where((f) => !f.date.isBefore(today)).toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  return list.take(limit).toList();
}

Festival? nextFestival() {
  final u = upcomingFestivals(limit: 1);
  return u.isEmpty ? null : u.first;
}
