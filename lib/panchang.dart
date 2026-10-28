import 'dart:math';

// Sunrise / sunset, returned as UTC DateTimes. The UI shows them via .toLocal(),
// which is correct for a user physically in the chosen city (device timezone
// matches, and handles daylight saving automatically).
class SunTimes {
  final DateTime? sunrise;
  final DateTime? sunset;
  const SunTimes(this.sunrise, this.sunset);
  bool get valid => sunrise != null && sunset != null;
}

double _rad(double d) => d * pi / 180.0;
double _deg(double r) => r * 180.0 / pi;

int _julianDayNumber(int y, int m, int d) {
  final a = (14 - m) ~/ 12;
  final yy = y + 4800 - a;
  final mm = m + 12 * a - 3;
  return d + ((153 * mm + 2) ~/ 5) + 365 * yy + (yy ~/ 4) - (yy ~/ 100) + (yy ~/ 400) - 32045;
}

DateTime _julianToUtc(double jd) {
  final ms = (jd - 2440587.5) * 86400000.0;
  return DateTime.fromMillisecondsSinceEpoch(ms.round(), isUtc: true);
}

// Standard sunrise equation (NOAA / Wikipedia).
SunTimes computeSunTimes(DateTime date, double lat, double lng) {
  final jdn = _julianDayNumber(date.year, date.month, date.day);
  final n = jdn - 2451545 + 0.0008;
  final jStar = n - lng / 360.0;
  final m = (357.5291 + 0.98560028 * jStar) % 360.0;
  final mr = _rad(m);
  final c = 1.9148 * sin(mr) + 0.0200 * sin(2 * mr) + 0.0003 * sin(3 * mr);
  final lambda = (m + c + 180.0 + 102.9372) % 360.0;
  final lr = _rad(lambda);
  final jTransit = 2451545.0 + jStar + 0.0053 * sin(mr) - 0.0069 * sin(2 * lr);
  final sinDelta = sin(lr) * sin(_rad(23.44));
  final cosDelta = cos(asin(sinDelta));
  final latR = _rad(lat);
  final cosOmega = (sin(_rad(-0.833)) - sin(latR) * sinDelta) / (cos(latR) * cosDelta);
  if (cosOmega >= 1 || cosOmega <= -1) return const SunTimes(null, null);
  final omega = _deg(acos(cosOmega));
  final jRise = jTransit - omega / 360.0;
  final jSet = jTransit + omega / 360.0;
  return SunTimes(_julianToUtc(jRise), _julianToUtc(jSet));
}

class KaalPeriod {
  final String name;
  final DateTime start; // UTC
  final DateTime end; // UTC
  const KaalPeriod(this.name, this.start, this.end);
}

// Which of the eight daytime segments each "kaal" falls in, by weekday
// (1 = Monday … 7 = Sunday).
const _rahu = {1: 2, 2: 7, 3: 5, 4: 6, 5: 4, 6: 3, 7: 8};
const _yamaganda = {1: 4, 2: 3, 3: 2, 4: 1, 5: 7, 6: 6, 7: 5};
const _gulika = {1: 6, 2: 5, 3: 4, 4: 3, 5: 2, 6: 1, 7: 7};

// The main inauspicious periods to avoid. Derived purely from sunrise/sunset
// and the weekday, so no astronomy library or network needed.
List<KaalPeriod> inauspiciousPeriods(DateTime date, double lat, double lng) {
  final s = computeSunTimes(date, lat, lng);
  if (!s.valid) return const [];
  final rise = s.sunrise!;
  final set = s.sunset!;
  final eighthMs = set.difference(rise).inMilliseconds / 8.0;

  KaalPeriod seg(String name, int segment) {
    final start = rise.add(Duration(milliseconds: ((segment - 1) * eighthMs).round()));
    final end = start.add(Duration(milliseconds: eighthMs.round()));
    return KaalPeriod(name, start, end);
  }

  final wd = date.weekday;
  return [
    seg('Rahu Kaal', _rahu[wd]!),
    seg('Yamaganda', _yamaganda[wd]!),
    seg('Gulika Kaal', _gulika[wd]!),
  ];
}
