abstract final class NasaApi {
  static const String _fallbackApiKey =
      'Ah79iXNawQ4pH4Yl9j29zLaf8fBMabbE1dB6GtvW';

  static const String apiKey = String.fromEnvironment(
    'NASA_API_KEY',
    defaultValue: _fallbackApiKey,
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
