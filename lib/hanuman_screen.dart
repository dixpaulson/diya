import 'package:flutter/material.dart';
import 'hanuman_data.dart';

const _saffron = Color(0xFFEB7A1D);
const _maroon = Color(0xFF6E1E1E);
const _cream = Color(0xFFFDF6EC);

const _intro =
    'The Hanuman Chalisa is a hymn of forty verses in praise of Hanuman, composed by the poet-saint Tulsidas around the 16th century. Beloved across the Hindu world, it is chanted for courage, strength, protection, and devotion. Read or recite it from start to finish.';

class HanumanChalisaScreen extends StatelessWidget {
  const HanumanChalisaScreen({super.key});

  List<Widget> _verses() {
    final widgets = <Widget>[];
    int chaupai = 0;
    for (final v in hanumanChalisa) {
      final String label = v.type == 'doha' ? 'Doha' : 'Chaupai ${++chaupai}';
      widgets.add(_VerseCard(verse: v, label: label));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: const Text('Hanuman Chalisa'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _saffron.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _saffron.withValues(alpha: 0.30)),
            ),
            child: const Text(_intro, style: TextStyle(color: _maroon, height: 1.5, fontSize: 14)),
          ),
          const SizedBox(height: 18),
          ..._verses(),
        ],
      ),
    );
  }
}

class _VerseCard extends StatelessWidget {
  final ChalisaVerse verse;
  final String label;
  const _VerseCard({required this.verse, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDoha = verse.type == 'doha';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDoha ? _saffron.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _saffron.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _saffron.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(label,
                style: const TextStyle(fontSize: 11, color: _saffron, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          Text(verse.native,
              style: const TextStyle(fontSize: 19, color: _maroon, height: 1.6, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(verse.transliteration,
              style: const TextStyle(fontSize: 14, color: _saffron, fontStyle: FontStyle.italic, height: 1.5)),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Text(verse.meaning, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5)),
        ],
      ),
    );
  }
}
