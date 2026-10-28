// Cities the user can pick for panchang calculations. We only need latitude and
// longitude — sunrise/sunset are computed from those, and shown in the device's
// local time (which matches the user's own city, the common case). GPS is an
// easy add later.
class City {
  final String name;
  final String country;
  final double lat;
  final double lng;
  const City(this.name, this.country, this.lat, this.lng);
}

const cityList = <City>[
  City('Toronto', 'Canada', 43.65, -79.38),
  City('Vancouver', 'Canada', 49.28, -123.12),
  City('New York', 'USA', 40.71, -74.01),
  City('New Jersey (Edison)', 'USA', 40.52, -74.41),
  City('Chicago', 'USA', 41.88, -87.63),
  City('Houston', 'USA', 29.76, -95.37),
  City('San Francisco', 'USA', 37.77, -122.42),
  City('Los Angeles', 'USA', 34.05, -118.24),
  City('London', 'UK', 51.51, -0.13),
  City('Dubai', 'UAE', 25.20, 55.27),
  City('Singapore', 'Singapore', 1.35, 103.82),
  City('Sydney', 'Australia', -33.87, 151.21),
  City('Melbourne', 'Australia', -37.81, 144.96),
  City('Delhi', 'India', 28.61, 77.21),
  City('Mumbai', 'India', 19.08, 72.88),
  City('Bengaluru', 'India', 12.97, 77.59),
  City('Chennai', 'India', 13.08, 80.27),
  City('Kolkata', 'India', 22.57, 88.36),
];

City? cityByName(String? name) {
  if (name == null) return null;
  for (final c in cityList) {
    if (c.name == name) return c;
  }
  return null;
}
