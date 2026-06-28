abstract final class NasaApi {
  // Supplied at build/run time via --dart-define-from-file=.env (gitignored)
  // or --dart-define=NASA_API_KEY=…. Falls back to NASA's public, rate-limited
  // DEMO_KEY so a flagless build still runs. Never hardcode a real key here.
  static const String apiKey = String.fromEnvironment(
    'NASA_API_KEY',
    defaultValue: 'DEMO_KEY',
  );

  static const String apodBase = 'https://api.nasa.gov/planetary/apod';
  static const String marsRoverBase =
      'https://api.nasa.gov/mars-photos/api/v1/rovers';
  static const String epicBase = 'https://api.nasa.gov/EPIC/api';
  static const String epicArchive = 'https://api.nasa.gov/EPIC/archive';
  static const String neoBase = 'https://api.nasa.gov/neo/rest/v1/feed';
  static const String donkiBase = 'https://api.nasa.gov/DONKI';
  static const String nasaImagesBase = 'https://images-api.nasa.gov';
  static const String issBase = 'https://api.open-notify.org/iss-now.json';
  static const String exoplanetBase =
      'https://exoplanetarchive.ipac.caltech.edu/TAP/sync';
}
