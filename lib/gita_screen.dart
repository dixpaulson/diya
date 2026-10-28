import 'package:flutter/material.dart';
import 'gita_data.dart';
import 'hanuman_screen.dart';
import 'favorites_screen.dart';
import 'i18n.dart';

const _saffron = Color(0xFFEB7A1D);
const _maroon = Color(0xFF6E1E1E);
const _cream = Color(0xFFFDF6EC);

List<GitaVerse> versesForChapter(int chapter) =>
    gitaVerses.where((v) => v.chapter == chapter).toList();

bool chapterTranslated(int chapter) =>
    versesForChapter(chapter).any((v) => v.meaning.isNotEmpty);

class GitaChapterInfo {
  final int number;
  final String sanskritTitle;
  final String englishTitle;
  const GitaChapterInfo(this.number, this.sanskritTitle, this.englishTitle);
}

const gitaChapters = <GitaChapterInfo>[
  GitaChapterInfo(1, 'Arjuna Vishada Yoga', 'Arjuna’s despair'),
  GitaChapterInfo(2, 'Sankhya Yoga', 'The yoga of knowledge'),
  GitaChapterInfo(3, 'Karma Yoga', 'The yoga of action'),
  GitaChapterInfo(4, 'Jnana Karma Sanyasa Yoga', 'The yoga of wisdom'),
  GitaChapterInfo(5, 'Karma Sanyasa Yoga', 'The yoga of renunciation'),
  GitaChapterInfo(6, 'Dhyana Yoga', 'The yoga of meditation'),
  GitaChapterInfo(7, 'Jnana Vijnana Yoga', 'Knowledge and realization'),
  GitaChapterInfo(8, 'Akshara Brahma Yoga', 'The imperishable absolute'),
  GitaChapterInfo(9, 'Raja Vidya Yoga', 'The royal knowledge'),
  GitaChapterInfo(10, 'Vibhuti Yoga', 'Divine glories'),
  GitaChapterInfo(11, 'Vishwarupa Darshana Yoga', 'The cosmic form'),
  GitaChapterInfo(12, 'Bhakti Yoga', 'The yoga of devotion'),
  GitaChapterInfo(13, 'Kshetra Kshetrajna Yoga', 'The field and its knower'),
  GitaChapterInfo(14, 'Gunatraya Vibhaga Yoga', 'The three qualities'),
  GitaChapterInfo(15, 'Purushottama Yoga', 'The supreme person'),
  GitaChapterInfo(16, 'Daivasura Sampad Yoga', 'The divine and the demonic'),
  GitaChapterInfo(17, 'Shraddhatraya Vibhaga Yoga', 'The threefold faith'),
  GitaChapterInfo(18, 'Moksha Sanyasa Yoga', 'Liberation through renunciation'),
];

const _chapterIntros = <int, String>{
  1: 'Chapter 1 sets the scene. The two great armies face each other at Kurukshetra. As Krishna drives Arjuna between them, Arjuna sees his own teachers, elders, and kinsmen arrayed to fight, and is overwhelmed with grief and doubt, laying down his bow. His despair is the very human crisis that the whole Gita sets out to answer.',
  2: 'Chapter 2, Sankhya Yoga, is the philosophical heart of the Gita. Overwhelmed on the battlefield, Arjuna refuses to fight. Krishna answers his despair with the core teaching: the soul is eternal and never truly dies, so act without fear; do your duty for its own sake, not for its rewards; and grow into a person of steady wisdom — calm and free amid life’s ups and downs.',
  3: 'Chapter 3, Karma Yoga, is the yoga of action. Arjuna asks: if wisdom is higher, why act at all? Krishna answers that no one can avoid action, so the real key is to act selflessly, doing your duty without clinging to results, as an offering, for the good of the world. He closes by naming desire and anger as the enemies to master.',
  4: 'Chapter 4 reveals the timeless source of this teaching and the mystery of the divine descents: whenever righteousness declines, the divine takes form to restore it. Krishna explains how the wise act without being bound, describes many kinds of sacrifice, and praises knowledge as the fire that burns away all karma.',
  5: 'Chapter 5, Karma Sanyasa Yoga, reconciles two paths. Arjuna asks whether it is better to renounce action or to act; Krishna answers that both lead to freedom, but selfless action is the easier road. The truly free person acts without attachment, offering everything to the divine, and stays unstained like a lotus leaf on water.',
  6: 'Chapter 6, Dhyana Yoga, is the Gita’s guide to meditation. Krishna describes how to sit, steady the breath, and still the mind — like a lamp that does not flicker in a windless place. When Arjuna protests that the mind is as restless as the wind, Krishna reassures him: with steady practice and non-attachment, even the mind can be tamed, and no sincere effort is ever wasted.',
  7: 'Chapter 7, Jnana Vijnana Yoga, turns to knowing the divine directly. Krishna reveals his lower nature — the elements, mind, and ego — and his higher nature, the life that sustains all, declaring that everything is strung upon him like beads on a thread: the taste in water, the light in the sun, the life in all beings. He names four kinds of seekers and calls the wise lover of God the dearest of all.',
  8: 'Chapter 8, Akshara Brahma Yoga, is about the Imperishable and the moment of death. Arjuna asks Krishna to explain Brahman, the Self, action, and how the Lord is known at life’s end. Krishna teaches that whatever we remember as we leave the body, we become — so remember Him always, and act. He describes the vast days and nights of Brahma in which worlds arise and dissolve, and the two paths of light and smoke by which souls depart.',
  9: 'Chapter 9, Raja Vidya Raja Guhya Yoga, is the royal knowledge and the royal secret. Krishna reveals that the whole universe rests in him as the wind rests in space, yet he remains untouched. He is the father, mother, friend, and refuge of all. He asks nothing grand: a leaf, a flower, a fruit, or a little water offered with love is enough. Whoever turns to him, whatever their past or birth, is never lost.',
  10: 'Chapter 10, Vibhuti Yoga, unveils the divine glories. Krishna declares himself the source of all, from whom every quality — wisdom, patience, fear, and fearlessness — arises. When Arjuna asks how to recognize him, Krishna names his chief manifestations: the sun among lights, Om among words, the Ganga among rivers, the Himalaya among mountains. Wherever there is greatness or beauty, it is a spark of his splendor — and a single fragment of him holds up the entire universe.',
  11: 'Chapter 11, Vishwarupa Darshana Yoga, is the vision of the cosmic form. Arjuna asks to see Krishna as he truly is, and Krishna grants him divine sight. Arjuna beholds the whole universe within one body, blazing like a thousand suns, then a terrifying form of Time devouring the warriors of both armies. Krishna tells him the outcome is already decided — be only the instrument. Shaken, Arjuna begs forgiveness and asks to see his friend’s gentle form again, and Krishna explains that such a vision is won not by ritual or austerity, but by devotion alone.',
  12: 'Chapter 12, Bhakti Yoga, is the yoga of devotion and one of the shortest chapters. Arjuna asks which is better: worshipping God with form, or the formless absolute. Krishna answers that both lead to him, but loving devotion is the easier path for embodied beings. He offers a gentle ladder — fix your mind on me; if you cannot, practice; if not that, work for my sake; if not even that, simply let go of results — and closes with a portrait of the devotee dear to him: free of hatred, kind, humble, content, and the same in praise and blame.',
  13: 'Chapter 13, Kshetra Kshetrajna Yoga, is about the field and its knower. Krishna calls the body, with its elements, mind, senses, and feelings, the field, and the conscious self that knows it the knower of the field, adding that he himself is the knower in every field. He lists the marks of true knowledge, such as humility, patience, and detachment, and describes the Supreme, which has hands and eyes everywhere and dwells in every heart, far away yet near. Whoever sees the one imperishable Lord within all perishing beings, he says, truly sees.',
  14: 'Chapter 14, Gunatraya Vibhaga Yoga, explains the three qualities of nature — sattva (goodness), rajas (passion), and tamas (darkness) — which bind every soul to the body. Sattva binds through attachment to happiness and knowledge, rajas through craving and restless action, and tamas through ignorance, laziness, and sleep. They constantly compete within us, and their pull reaches even beyond death. Krishna then describes the one who has risen above all three: calm in pleasure and pain, praise and blame, treating a clod of earth, a stone, and gold alike — a freedom reached through unwavering devotion.',
  15: 'Chapter 15, Purushottama Yoga, is the yoga of the Supreme Person. Krishna pictures the world as an eternal fig tree with its roots above and branches below, nourished by the senses and bound to us through action, and tells Arjuna to cut it down with the axe of detachment and seek the source from which it grew. Every living soul, he says, is an eternal part of him; his is the light in the sun, moon, and fire, and he dwells in every heart. Beyond both the perishable world and the imperishable self stands the Supreme Person, and whoever knows him so knows everything.',
  16: 'Chapter 16, Daivasura Sampad Vibhaga Yoga, contrasts the divine and the demonic natures. Krishna lists the divine qualities — fearlessness, purity, generosity, truthfulness, compassion, forgiveness, and humility — which lead to freedom, and reassures Arjuna that he was born with them. He then paints the demonic mind: driven by endless desire, proud of wealth and power, and sure that the world has no God and no purpose but pleasure. Desire, anger, and greed, he warns, are the three gates of hell, and he closes by urging Arjuna to let scripture guide what should and should not be done.',
};

// The Vidya tab: sacred texts and (later) stories.
class VidyaTab extends StatelessWidget {
  const VidyaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          Text(t('vidya_title'),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 4),
          Text(t('vidya_subtitle'), style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 20),
          const Text('Sacred texts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 10),
          _card(context, 'Bhagavad Gita', 'The song of the Lord · all 18 chapters', true,
              () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const GitaChaptersScreen()))),
          _card(context, 'Hanuman Chalisa', '40 verses in praise of Hanuman', true,
              () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const HanumanChalisaScreen()))),
          _card(context, 'Upanishads', 'Coming soon', false, null),
          const SizedBox(height: 24),
          const Text('Stories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 10),
          _card(context, 'Kids’ stories', 'Coming soon', false, null),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, String title, String subtitle, bool ready, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: _saffron.withValues(alpha: ready ? 0.35 : 0.15)),
          ),
          leading: Icon(ready ? Icons.menu_book : Icons.lock_outline,
              color: ready ? _saffron : Colors.black26),
          title: Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, color: ready ? _maroon : Colors.black45)),
          subtitle: Text(subtitle, style: const TextStyle(color: Colors.black54)),
          trailing: ready ? const Icon(Icons.chevron_right, color: _saffron) : null,
          onTap: onTap,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool translated;
  const _StatusBadge(this.translated);
  @override
  Widget build(BuildContext context) {
    final color = translated ? _saffron : Colors.black38;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(translated ? 'Diya' : 'Sanskrit only',
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
    );
  }
}

// Lists all 18 chapters — all browsable.
class GitaChaptersScreen extends StatelessWidget {
  const GitaChaptersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: const Text('Bhagavad Gita'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          const Text('The Song of the Lord',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 6),
          const Text(
              '701 verses across 18 chapters. Every verse is here in Sanskrit with transliteration; English is being added chapter by chapter (Chapters 1–16 so far).',
              style: TextStyle(color: Colors.black54, height: 1.4)),
          const SizedBox(height: 16),
          for (final c in gitaChapters)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: _saffron.withValues(alpha: 0.22)),
                  ),
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: _saffron.withValues(alpha: 0.15),
                    child: Text('${c.number}',
                        style: const TextStyle(
                            color: _saffron, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  title: Text(c.englishTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon)),
                  subtitle: Text('${c.sanskritTitle} · ${versesForChapter(c.number).length} verses',
                      style: const TextStyle(color: Colors.black54)),
                  trailing: _StatusBadge(chapterTranslated(c.number)),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => GitaChapterScreen(chapter: c.number))),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// One chapter, as a continuous scroll of verse cards.
class GitaChapterScreen extends StatelessWidget {
  final int chapter;
  const GitaChapterScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final info = gitaChapters[chapter - 1];
    final verses = versesForChapter(chapter);
    final intro = _chapterIntros[chapter];
    final translated = chapterTranslated(chapter);
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: Text('Chapter $chapter · ${info.sanskritTitle}'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        itemCount: verses.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.englishTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _maroon)),
                const SizedBox(height: 10),
                if (intro != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _saffron.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _saffron.withValues(alpha: 0.30)),
                    ),
                    child: Text(intro, style: const TextStyle(color: _maroon, height: 1.5, fontSize: 14)),
                  ),
                  const SizedBox(height: 14),
                ],
                if (!translated)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 14),
                    child: Text('English translation coming soon — for now, read along in Sanskrit.',
                        style: TextStyle(color: Colors.black54, fontSize: 13)),
                  ),
                Text('${verses.length} verses',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon, fontSize: 16)),
                const SizedBox(height: 12),
              ],
            );
          }
          return _GitaVerseCard(verse: verses[i - 1]);
        },
      ),
    );
  }
}

class _GitaVerseCard extends StatelessWidget {
  final GitaVerse verse;
  const _GitaVerseCard({required this.verse});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(18, 8, 8, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _saffron.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _saffron.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${verse.chapter}.${verse.verse}',
                    style: const TextStyle(fontSize: 11, color: _saffron, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              FavoriteButton(id: 'gita:${verse.chapter}.${verse.verse}', color: _saffron),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(verse.sanskrit,
                    style: const TextStyle(
                        fontSize: 19, color: _maroon, height: 1.6, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(verse.transliteration,
                    style: const TextStyle(
                        fontSize: 14, color: _saffron, fontStyle: FontStyle.italic, height: 1.5)),
                if (verse.meaning.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  if (verse.inShort.isNotEmpty) ...[
                    Text(verse.inShort,
                        style: const TextStyle(
                            fontSize: 14,
                            color: _maroon,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            height: 1.4)),
                    const SizedBox(height: 8),
                  ],
                  Text(verse.meaning,
                      style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// A single verse — used when opening a saved verse from favorites.
class GitaVerseScreen extends StatefulWidget {
  final int chapter;
  final int index;
  const GitaVerseScreen({super.key, required this.chapter, required this.index});

  @override
  State<GitaVerseScreen> createState() => _GitaVerseScreenState();
}

class _GitaVerseScreenState extends State<GitaVerseScreen> {
  late int _i = widget.index;

  @override
  Widget build(BuildContext context) {
    final verses = versesForChapter(widget.chapter);
    final v = verses[_i];
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: Text('Chapter ${v.chapter} · Verse ${v.verse}'),
        actions: [FavoriteButton(id: 'gita:${v.chapter}.${v.verse}')],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _saffron.withValues(alpha: 0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v.sanskrit,
                    style: const TextStyle(
                        fontSize: 20, color: _maroon, height: 1.6, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Text(v.transliteration,
                    style: const TextStyle(
                        fontSize: 15, color: _saffron, fontStyle: FontStyle.italic, height: 1.5)),
                if (v.meaning.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text(v.meaning,
                      style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _i > 0 ? () => setState(() => _i--) : null,
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Previous'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: _saffron),
                  onPressed: _i < verses.length - 1 ? () => setState(() => _i++) : null,
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
