import 'package:flutter/foundation.dart';

// The user's chosen deity (null until they pick one). Held in memory for now;
// Profile saves it to the device so it's remembered between visits.
final favouriteDeity = ValueNotifier<String?>(null);

// The current daily streak — days in a row the app has been opened.
final streakCount = ValueNotifier<int>(0);

// IDs of saved items, e.g. 'prayer:Gayatri Mantra' or 'gita:2.47'.
final favorites = ValueNotifier<Set<String>>(<String>{});

// The user's chosen city for panchang (sunrise, auspicious times). Null until set.
final selectedCityName = ValueNotifier<String?>(null);
