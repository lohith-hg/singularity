import 'package:flutter_test/flutter_test.dart';
import 'package:singularity/features/cosmo_daily/data/models/apod_model.dart';
import 'package:singularity/features/exoplanets/data/models/exoplanet_model.dart';
import 'package:singularity/features/iss_tracker/data/models/iss_position_model.dart';

void main() {
  test('APOD parser accepts a single object and missing optional fields', () {
    final models = apodListFromJson(
      '{"date":"2026-05-09","title":"Test APOD","url":"https://example.com/a.jpg"}',
    );

    expect(models, hasLength(1));
    expect(models.first.copyright, 'NASA');
    expect(models.first.explanation, '');
    expect(models.first.serviceVersion, 'v1');
  });

  test('Exoplanet parser accepts numeric strings', () {
    final model = ExoplanetModel.fromJson(const {
      'pl_name': 'Kepler Test b',
      'pl_rade': '1.5',
      'pl_bmasse': '2.1',
      'pl_orbper': '42.0',
      'sy_dist': '100.5',
      'disc_year': '2026',
    });

    expect(model.radiusEarth, 1.5);
    expect(model.massEarth, 2.1);
    expect(model.discoveryYear, 2026);
  });

  test('ISS parser accepts numeric latitude and longitude', () {
    final model = IssPositionModel.fromJson(const {
      'iss_position': {'latitude': 12.5, 'longitude': '-20.25'},
      'timestamp': '123',
    });

    expect(model.lat, 12.5);
    expect(model.lon, -20.25);
    expect(model.timestamp, 123);
  });
}
