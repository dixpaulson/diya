// Each weekday has a presiding deity in Hindu tradition. This powers the
// "Today's day & deity" card — a warm daily reason to open, and very shareable.
class WeekdayInfo {
  final String deity;
  final String significance;
  final String mantra;
  final List<String> whatToDo;
  const WeekdayInfo({
    required this.deity,
    required this.significance,
    required this.mantra,
    required this.whatToDo,
  });
}

// Keyed by DateTime.weekday (1 = Monday … 7 = Sunday).
const _weekdayInfo = <int, WeekdayInfo>{
  1: WeekdayInfo(
    deity: 'Shiva',
    significance:
        'Monday is dedicated to Shiva — a day for calm, letting go, and inner stillness. Many keep a light fast and visit a Shiva temple.',
    mantra: 'Om Namah Shivaya',
    whatToDo: ['Offer water or milk to a Shivling', 'Chant Om Namah Shivaya', 'Light a lamp in the evening'],
  ),
  2: WeekdayInfo(
    deity: 'Hanuman',
    significance:
        'Tuesday honors Hanuman, the embodiment of strength, courage, and devotion — a good day to face challenges and ask for protection.',
    mantra: 'Om Hanumate Namaha',
    whatToDo: ['Read the Hanuman Chalisa', 'Chant Om Hanumate Namaha', 'Offer a red flower or sindoor'],
  ),
  3: WeekdayInfo(
    deity: 'Ganesha',
    significance:
        'Wednesday belongs to Ganesha, remover of obstacles — an auspicious day to begin new things and seek a clear path.',
    mantra: 'Om Gam Ganapataye Namaha',
    whatToDo: ['Begin a new task or plan', 'Offer durva grass or modak', 'Chant Om Gam Ganapataye Namaha'],
  ),
  4: WeekdayInfo(
    deity: 'Vishnu & the Guru',
    significance:
        'Thursday honors Vishnu and the guru (Brihaspati) — a day for wisdom, gratitude, and respect for teachers and elders.',
    mantra: 'Om Namo Bhagavate Vasudevaya',
    whatToDo: ['Thank a teacher or mentor', 'Offer yellow flowers or sweets', 'Chant Om Namo Bhagavate Vasudevaya'],
  ),
  5: WeekdayInfo(
    deity: 'Lakshmi & the Divine Mother',
    significance:
        'Friday is for Lakshmi and the Goddess — a day for abundance, beauty, and grace. Many clean and light the home in the evening.',
    mantra: 'Om Shreem Mahalakshmiyei Namaha',
    whatToDo: ['Clean and light your home', 'Offer a white or pink flower', 'Chant the Lakshmi mantra'],
  ),
  6: WeekdayInfo(
    deity: 'Shani & Hanuman',
    significance:
        'Saturday is for Shani and Hanuman — a day for discipline, humility, and service. A good day to give to those in need.',
    mantra: 'Om Sham Shanaishcharaya Namaha',
    whatToDo: ['Do an act of service or charity', 'Read the Hanuman Chalisa', 'Light a sesame-oil lamp'],
  ),
  7: WeekdayInfo(
    deity: 'Surya',
    significance:
        'Sunday belongs to Surya, the sun — a day for health, vitality, and fresh starts. Offering water to the rising sun is a simple, powerful practice.',
    mantra: 'Om Suryaya Namaha',
    whatToDo: ['Offer water to the rising sun', 'Chant the Gayatri Mantra', 'Set an intention for the week'],
  ),
};

const _weekdayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

WeekdayInfo weekdayToday() => _weekdayInfo[DateTime.now().weekday]!;
String weekdayName() => _weekdayNames[DateTime.now().weekday - 1];
