// The shape of a single line of a prayer: the three "layers" that make Diya
// special — the original script, how to say it, and what it means.
class PrayerLine {
  final String native;
  final String transliteration;
  final String meaning;
  const PrayerLine({
    required this.native,
    required this.transliteration,
    required this.meaning,
  });
}

class Prayer {
  final String title;
  final String deity;
  final String context;
  final String inShort;
  final String whyWeChant;
  final List<String> moods; // feelings this prayer suits
  final List<String> goals; // life goals / needs this prayer suits
  final String audioAsset;
  final List<PrayerLine> lines;

  const Prayer({
    required this.title,
    required this.deity,
    required this.context,
    required this.inShort,
    required this.whyWeChant,
    required this.lines,
    this.moods = const [],
    this.goals = const [],
    this.audioAsset = '',
  });
}

List<Prayer> prayersForDeity(String deity) =>
    samplePrayers.where((p) => p.deity == deity).toList();

List<Prayer> prayersForMood(String mood) =>
    samplePrayers.where((p) => p.moods.contains(mood)).toList();

List<Prayer> prayersForGoal(String goal) =>
    samplePrayers.where((p) => p.goals.contains(goal)).toList();

// The need/goal categories shown in the "find a mantra for…" grid.
const goalCategories = <String>[
  'Wealth', 'Career', 'Health', 'Healing', 'Relationships', 'Peace',
  'Protection', 'Courage', 'Focus', 'Wisdom', 'Gratitude', 'New beginnings',
];

const samplePrayers = <Prayer>[
  Prayer(
    title: 'Gayatri Mantra',
    deity: 'Surya',
    context: 'A prayer for clarity and inner light. Traditionally said at sunrise.',
    inShort:
        'O divine light, our minds are clouded by darkness. Drive that darkness far from us, and awaken clarity, wisdom, and understanding within.',
    whyWeChant:
        'It is traditionally chanted at sunrise to begin the day with a clear, positive intention. The slow, steady repetition works like a focusing meditation — it lengthens the breath and quiets a busy mind — which is part of why it has been passed down for over three thousand years.',
    moods: ['Peaceful', 'Hopeful'],
    goals: ['Focus', 'Wisdom', 'Peace'],
    lines: [
      PrayerLine(native: 'ॐ भूर्भुवः स्वः', transliteration: 'Om bhūr bhuvaḥ svaḥ', meaning: 'Om. The earth, the atmosphere, and the heavens.'),
      PrayerLine(native: 'तत्सवितुर्वरेण्यं', transliteration: 'tat savitur vareṇyaṃ', meaning: 'That supreme, adorable light of the divine Sun,'),
      PrayerLine(native: 'भर्गो देवस्य धीमहि', transliteration: 'bhargo devasya dhīmahi', meaning: 'on that radiant glory of the divine we meditate.'),
      PrayerLine(native: 'धियो यो नः प्रचोदयात्', transliteration: 'dhiyo yo naḥ prachodayāt', meaning: 'May it inspire and illumine our thoughts.'),
    ],
  ),
  Prayer(
    title: 'Ganesha Mantra',
    deity: 'Ganesha',
    context: 'Said before beginning anything new, to remove obstacles.',
    inShort:
        'Before I begin anything new, I pause and ask for a clear path — please remove whatever stands in my way, outside and within.',
    whyWeChant:
        'Ganesha is the remover of obstacles, so this is said at the start of journeys, exams, weddings, and new ventures. As a small ritual it marks a beginning and settles the nerves, turning “I am anxious” into “I am ready.”',
    moods: ['Hopeful', 'Anxious'],
    goals: ['New beginnings', 'Career'],
    lines: [
      PrayerLine(native: 'ॐ गं गणपतये नमः', transliteration: 'Om Gaṃ Gaṇapataye Namaḥ', meaning: 'Om. Salutations to Ganesha, remover of obstacles.'),
    ],
  ),
  Prayer(
    title: 'Maha Mrityunjaya Mantra',
    deity: 'Shiva',
    context: 'A prayer for healing, protection, and courage in hard times.',
    inShort:
        'Heal me and hold me. When fear or illness grips me, let me be released from it as gently as a ripe fruit falls from the vine.',
    whyWeChant:
        'A prayer for healing, protection, and courage — often chanted for oneself or a loved one during illness or grief. Its long, resonant sounds naturally slow the breath and calm the body’s stress response, which is why many people find it steadying in hard times.',
    moods: ['Anxious', 'Grieving', 'Hopeful'],
    goals: ['Health', 'Healing', 'Protection'],
    lines: [
      PrayerLine(native: 'ॐ त्र्यम्बकं यजामहे सुगन्धिं पुष्टिवर्धनम्', transliteration: 'Om tryambakaṃ yajāmahe sugandhiṃ puṣṭi-vardhanam', meaning: 'We worship the three-eyed one, fragrant, who nourishes all beings.'),
      PrayerLine(native: 'उर्वारुकमिव बन्धनान् मृत्योर्मुक्षीय मामृतात्', transliteration: 'urvārukam iva bandhanān mṛtyor mukṣīya māmṛtāt', meaning: 'As a ripe fruit is freed from its stem, may we be freed from death, into immortality.'),
    ],
  ),
  Prayer(
    title: 'Om Namah Shivaya',
    deity: 'Shiva',
    context: 'One of the simplest, most beloved mantras — for peace and letting go.',
    inShort: 'I bow to the stillness at the center of everything, and to that same stillness within me.',
    whyWeChant:
        'Known as the “five-syllable” mantra, it is simple enough to repeat anywhere. Its steady rhythm helps quiet mental chatter, and many use it to settle the mind before meditation or sleep.',
    moods: ['Peaceful', 'Anxious'],
    goals: ['Peace', 'Focus'],
    lines: [
      PrayerLine(native: 'ॐ नमः शिवाय', transliteration: 'Om Namaḥ Śivāya', meaning: 'Om. I bow to Shiva — the pure awareness within all.'),
    ],
  ),
  Prayer(
    title: 'Hare Krishna Maha Mantra',
    deity: 'Krishna',
    context: 'A joyful chant of the names of God, sung in kirtan.',
    inShort: 'I sing your names again and again, Krishna and Rama, until my restless heart grows quiet and glad.',
    whyWeChant:
        'This is the heart of bhakti (devotion) — singing God’s names in call-and-response kirtan. The melody and repetition lift the mood and bring people together, which is why it is sung in groups around the world.',
    moods: ['Grateful', 'Hopeful'],
    goals: ['Gratitude', 'Peace'],
    lines: [
      PrayerLine(native: 'हरे कृष्ण हरे कृष्ण कृष्ण कृष्ण हरे हरे', transliteration: 'Hare Kṛṣṇa Hare Kṛṣṇa, Kṛṣṇa Kṛṣṇa Hare Hare', meaning: 'O Krishna, O divine energy of the Lord, draw my heart to you.'),
      PrayerLine(native: 'हरे राम हरे राम राम राम हरे हरे', transliteration: 'Hare Rāma Hare Rāma, Rāma Rāma Hare Hare', meaning: 'O Rama, O joy of the soul, let my mind rest in your name.'),
    ],
  ),
  Prayer(
    title: 'Vishnu Mantra',
    deity: 'Vishnu',
    context: 'A great mantra of surrender and refuge, for peace and protection.',
    inShort: 'I place myself in your care, Lord of all — hold me, and all beings, gently.',
    whyWeChant:
        'A twelve-syllable mantra of surrender and trust. It is chanted to cultivate a sense of refuge and calm, letting go of the need to control everything.',
    moods: ['Anxious', 'Peaceful'],
    goals: ['Peace', 'Protection'],
    lines: [
      PrayerLine(native: 'ॐ नमो भगवते वासुदेवाय', transliteration: 'Om Namo Bhagavate Vāsudevāya', meaning: 'Om. I bow to Vasudeva (Vishnu), who dwells in all beings.'),
    ],
  ),
  Prayer(
    title: 'Mahalakshmi Mantra',
    deity: 'Lakshmi',
    context: 'For prosperity, well-being, and gratitude. Chanted on Fridays and at Diwali.',
    inShort: 'May grace and abundance flow into my life and home — not just wealth, but health, warmth, and harmony.',
    whyWeChant:
        'Lakshmi represents abundance in every sense — money, health, beauty, and harmony. Chanting it is a way of cultivating gratitude and a mindset of plenty, especially during Diwali.',
    moods: ['Grateful', 'Hopeful'],
    goals: ['Wealth', 'Gratitude'],
    lines: [
      PrayerLine(native: 'ॐ श्रीं महालक्ष्म्यै नमः', transliteration: 'Om Śrīṃ Mahālakṣmyai Namaḥ', meaning: 'Om. Salutations to Mahalakshmi, source of abundance and grace.'),
    ],
  ),
  Prayer(
    title: 'Saraswati Mantra',
    deity: 'Saraswati',
    context: 'For studies, music, and creativity. Loved by students before exams.',
    inShort: 'Goddess of learning, clear my mind and let knowledge, music, and words flow through me.',
    whyWeChant:
        'Saraswati is the muse of learning and art. Students chant it before exams and musicians before performing — as much to focus and calm the nerves as for blessing.',
    moods: ['Anxious', 'Hopeful'],
    goals: ['Focus', 'Wisdom', 'Career'],
    lines: [
      PrayerLine(native: 'ॐ ऐं सरस्वत्यै नमः', transliteration: 'Om Aiṃ Sarasvatyai Namaḥ', meaning: 'Om. Salutations to Saraswati, goddess of knowledge and the arts.'),
    ],
  ),
  Prayer(
    title: 'Durga Mantra',
    deity: 'Durga',
    context: 'For strength, courage, and protection. Central to Navratri.',
    inShort: 'Divine Mother, be my strength and my shield — stand with me when I am afraid.',
    whyWeChant:
        'Durga is the warrior mother who protects her children. This is chanted for courage in difficulty, and is at the heart of the nine nights of Navratri.',
    moods: ['Anxious', 'Hopeful'],
    goals: ['Protection', 'Courage'],
    lines: [
      PrayerLine(native: 'ॐ दुं दुर्गायै नमः', transliteration: 'Om Duṃ Durgāyai Namaḥ', meaning: 'Om. Salutations to Durga, the fierce and protecting Mother.'),
    ],
  ),
  Prayer(
    title: 'Hanuman Mantra',
    deity: 'Hanuman',
    context: 'For courage, strength, and steadfast devotion.',
    inShort: 'Give me courage and strength, and a heart as loyal and fearless as Hanuman’s.',
    whyWeChant:
        'Hanuman is the model of strength joined with humility and devotion. People chant to him for courage when facing something hard, and for protection along the way.',
    moods: ['Anxious', 'Hopeful'],
    goals: ['Courage', 'Protection', 'Health'],
    lines: [
      PrayerLine(native: 'ॐ हं हनुमते नमः', transliteration: 'Om Haṃ Hanumate Namaḥ', meaning: 'Om. Salutations to Hanuman, the fearless and devoted.'),
    ],
  ),
  Prayer(
    title: 'Rama Mantra',
    deity: 'Rama',
    context: 'For inner peace, integrity, and a steady mind.',
    inShort: 'Help me walk the right path with a calm and steady heart, as Rama did.',
    whyWeChant:
        'Rama represents living with integrity even when it is hard. His name is chanted for peace of mind — “Ram Ram” is a common greeting and a quiet comfort in many homes.',
    moods: ['Peaceful', 'Grieving'],
    goals: ['Peace', 'Relationships'],
    lines: [
      PrayerLine(native: 'ॐ श्री रामाय नमः', transliteration: 'Om Śrī Rāmāya Namaḥ', meaning: 'Om. Salutations to Rama, the embodiment of virtue and duty.'),
    ],
  ),
];
