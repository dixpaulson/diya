import 'package:flutter/material.dart';
import 'prayer.dart';

const _saffron = Color(0xFFEB7A1D);
const _maroon = Color(0xFF6E1E1E);
const _cream = Color(0xFFFDF6EC);

// A simple mala/jaap counter. The full mantra is shown so you can read along;
// tap anywhere to count a repetition (a full round is 108).
class JaapScreen extends StatefulWidget {
  final String title;
  final List<PrayerLine> lines;
  const JaapScreen({super.key, required this.title, required this.lines});

  @override
  State<JaapScreen> createState() => _JaapScreenState();
}

class _JaapScreenState extends State<JaapScreen> {
  static const _target = 108;
  int _count = 0;

  void _tap() {
    setState(() => _count++);
    if (_count % _target == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('One mala of 108 complete 🙏')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rounds = _count ~/ _target;
    final inRound = _count % _target;
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: const Text('Jaap'),
        actions: [
          IconButton(
            tooltip: 'Reset',
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _count = 0),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _tap,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _maroon)),
              const SizedBox(height: 12),
              // The whole mantra, so the user can read along.
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _saffron.withValues(alpha: 0.25)),
                ),
                child: Column(
                  children: [
                    for (final line in widget.lines) ...[
                      Text(line.native,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, color: _maroon, height: 1.5, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(line.transliteration,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13, color: _saffron, fontStyle: FontStyle.italic)),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: _saffron, width: 4),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$inRound',
                          style: const TextStyle(
                              fontSize: 60, fontWeight: FontWeight.bold, color: _maroon, height: 1)),
                      const Text('of 108', style: TextStyle(color: Colors.black54, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (rounds > 0)
                Text('$rounds mala${rounds == 1 ? '' : 's'} complete',
                    style: const TextStyle(color: _saffron, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Text('Tap anywhere to count', style: TextStyle(color: Colors.black45)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
