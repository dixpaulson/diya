import 'package:flutter/material.dart';
import 'deity_screen.dart';
import 'profile.dart';
import 'state.dart';
import 'main.dart';

const _saffron = Color(0xFFEB7A1D);
const _maroon = Color(0xFF6E1E1E);
const _cream = Color(0xFFFDF6EC);

// Shown only the first time the app opens. Three steps: welcome, choose a
// deity, and enter birth details for astrology. Everything is saved on exit.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  String? _deity;
  DateTime? _date;
  TimeOfDay? _time;
  final _place = TextEditingController();

  @override
  void dispose() {
    _place.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    favouriteDeity.value = _deity; // saved automatically by Profile
    await Profile.finishOnboarding(
      birthDate: _date == null
          ? null
          : '${_date!.year}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}',
      birthTime: _time == null ? null : '${_time!.hour}:${_time!.minute.toString().padLeft(2, '0')}',
      birthPlace: _place.text,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RootPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: switch (_step) {
          0 => _welcome(),
          1 => _chooseDeity(),
          _ => _birthDetails(),
        },
      ),
    );
  }

  Widget _welcome() {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_fire_department, color: _saffron, size: 72),
          const SizedBox(height: 20),
          const Text('Welcome to Diya',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 10),
          const Text(
            'Prayers, hymns, and stories — in your language, explained simply. Let’s make it yours.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _saffron,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => setState(() => _step = 1),
              child: const Text('Get started', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chooseDeity() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('Choose your deity',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 6),
          const Text('You can change this anytime.',
              style: TextStyle(fontSize: 15, color: Colors.black54)),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.4,
              children: [
                for (final d in deities)
                  _selectableDeity(d),
              ],
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => setState(() => _step = 2),
                child: const Text('Skip', style: TextStyle(color: Colors.black54)),
              ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _saffron,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                onPressed: () => setState(() => _step = 2),
                child: const Text('Continue'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selectableDeity(Deity d) {
    final selected = _deity == d.name;
    return InkWell(
      onTap: () => setState(() => _deity = d.name),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? _saffron.withValues(alpha: 0.15) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _maroon : _saffron.withValues(alpha: 0.25),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            deityAvatar(d, radius: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(d.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon)),
            ),
            if (selected) const Icon(Icons.check_circle, color: _maroon, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _birthDetails() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('A personal touch',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 6),
          const Text(
            'Your birth details power your personal horoscope and daily readings. This stays private on your device.',
            style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 20),
          _pickerTile(
            icon: Icons.cake_outlined,
            label: 'Birth date',
            value: _date == null
                ? 'Select'
                : '${_date!.year}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}',
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1920),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _date = picked);
            },
          ),
          const SizedBox(height: 12),
          _pickerTile(
            icon: Icons.access_time,
            label: 'Birth time',
            value: _time == null ? 'Select' : _time!.format(context),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 6, minute: 0),
              );
              if (picked != null) setState(() => _time = picked);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _place,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.place_outlined, color: _saffron),
              labelText: 'Birth place (city)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: _saffron.withValues(alpha: 0.3)),
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              TextButton(
                onPressed: _finish,
                child: const Text('Skip for now', style: TextStyle(color: Colors.black54)),
              ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _saffron,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                onPressed: _finish,
                child: const Text('Finish'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pickerTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _saffron.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: _saffron),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontSize: 16, color: _maroon)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 15, color: Colors.black54)),
            const Icon(Icons.chevron_right, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
