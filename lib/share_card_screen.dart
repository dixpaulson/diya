import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'reflection.dart';

const _saffron = Color(0xFFEB7A1D);
const _maroon = Color(0xFF6E1E1E);
const _cream = Color(0xFFFDF6EC);

class VerseCardScreen extends StatefulWidget {
  final DailyItem item;
  const VerseCardScreen({super.key, required this.item});

  @override
  State<VerseCardScreen> createState() => _VerseCardScreenState();
}

class _VerseCardScreenState extends State<VerseCardScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _busy = false;

  String get _shareText => '“${widget.item.quote}”\n— ${widget.item.source}\n\nShared from Diya 🪔';

  Future<void> _share() async {
    setState(() => _busy = true);
    try {
      final boundary = _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      await SharePlus.instance.share(
        ShareParams(
          text: _shareText,
          files: [XFile.fromData(bytes, name: 'diya-verse.png', mimeType: 'image/png')],
        ),
      );
    } catch (_) {
      // Where image sharing isn't supported (e.g. desktop web), copy the text.
      await Clipboard.setData(ClipboardData(text: _shareText));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied — paste it into WhatsApp')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: const Text('Verse of the day'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(key: _cardKey, child: _ShareCard(item: widget.item)),
              const SizedBox(height: 24),
              SizedBox(
                width: 320,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: _saffron,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _busy ? null : _share,
                  icon: const Icon(Icons.share),
                  label: Text(_busy ? 'Preparing…' : 'Share this card'),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Send today’s verse to family and friends',
                  style: TextStyle(color: Colors.black54, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

// The card that becomes the shared image.
class _ShareCard extends StatelessWidget {
  final DailyItem item;
  const _ShareCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _saffron.withValues(alpha: 0.4), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.local_fire_department, color: _saffron, size: 20),
              SizedBox(width: 6),
              Text('DIYA',
                  style: TextStyle(
                      color: _saffron, fontWeight: FontWeight.bold, letterSpacing: 3, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 22),
          if (item.native.isNotEmpty) ...[
            Text(item.native,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: _saffron, height: 1.6)),
            const SizedBox(height: 16),
          ],
          Text('“${item.quote}”',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20, color: _maroon, height: 1.45, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          Text(item.source,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.black54, fontStyle: FontStyle.italic)),
          const SizedBox(height: 22),
          Container(height: 1, color: _saffron.withValues(alpha: 0.3)),
          const SizedBox(height: 14),
          const Text('Keep the light burning',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black45)),
        ],
      ),
    );
  }
}
