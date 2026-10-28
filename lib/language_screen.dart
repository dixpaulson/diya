import 'package:flutter/material.dart';
import 'i18n.dart';

const _saffron = Color(0xFFEB7A1D);
const _maroon = Color(0xFF6E1E1E);
const _cream = Color(0xFFFDF6EC);

class LanguagePickerScreen extends StatelessWidget {
  const LanguagePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: Text(t('language')),
      ),
      body: ValueListenableBuilder<AppLang>(
        valueListenable: currentLang,
        builder: (context, current, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            children: [
              const Text(
                'English is fully available now. Hindi is partly translated, and Telugu, Tamil, Gujarati, and Malayalam are being added.',
                style: TextStyle(color: Colors.black54, height: 1.4),
              ),
              const SizedBox(height: 14),
              for (final lang in AppLang.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: current == lang ? _maroon : _saffron.withValues(alpha: 0.2),
                          width: current == lang ? 2 : 1,
                        ),
                      ),
                      title: Text(lang.nativeName,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon)),
                      subtitle: Text(lang.englishName, style: const TextStyle(color: Colors.black54)),
                      trailing: current == lang ? const Icon(Icons.check_circle, color: _maroon) : null,
                      onTap: () {
                        currentLang.value = lang;
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
