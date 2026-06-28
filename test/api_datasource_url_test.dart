import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:singularity/core/network/api_client.dart';
import 'package:singularity/features/cosmo_daily/data/datasources/apod_remote_datasource.dart';
import 'package:singularity/features/exoplanets/data/datasources/exoplanets_remote_datasource.dart';
import 'package:singularity/features/mars_rover/data/datasources/mars_rover_remote_datasource.dart';
import 'package:singularity/features/neo/data/datasources/neo_remote_datasource.dart';

void main() {
  test('APOD datasource builds encoded date-range request', () async {
    Uri? requestedUri;
    final dataSource = ApodRemoteDataSourceImpl(
      apiClient: ApiClient(
        client: MockClient((request) async {
          requestedUri = request.url;
          return http.Response('[]', 200);
        }),
      ),
    );

    await dataSource.fetchApods(
      startDate: DateTime.utc(2026, 5, 9, 13),
      daysBack: 2,
    );

    expect(requestedUri?.host, 'api.nasa.gov');
    expect(requestedUri?.path, '/planetary/apod');
    expect(requestedUri?.queryParameters['start_date'], '2026-05-07');
    expect(requestedUri?.queryParameters['end_date'], '2026-05-09');
    expect(requestedUri?.queryParameters['thumbs'], 'true');
  });

  test(
    'Mars datasource requests NASA image search by rover and page',
    () async {
      Uri? requestedUri;
      final dataSource = MarsRoverRemoteDataSourceImpl(
        apiClient: ApiClient(
          client: MockClient((request) async {
            requestedUri = request.url;
            return http.Response('{"collection":{"items":[]}}', 200);
          }),
        ),
      );

      final resource = dataSource.getRoverPhotos(rover: 'Curiosity', page: 2);
      await resource.refresh();

      expect(requestedUri?.path, '/search');
      expect(requestedUri?.queryParameters['q'], 'Curiosity rover mars');
      expect(requestedUri?.queryParameters['media_type'], 'image');
      expect(requestedUri?.queryParameters['page'], '2');
      expect(requestedUri?.queryParameters['page_size'], '25');
    },
  );

  test('NeoWs datasource clamps ranges above seven days', () async {
    Uri? requestedUri;
    final dataSource = NeoRemoteDataSourceImpl(
      apiClient: ApiClient(
        client: MockClient((request) async {
          requestedUri = request.url;
          return http.Response('{"near_earth_objects":{}}', 200);
        }),
      ),
    );

    final resource = dataSource.getNeos(
      startDate: '2026-05-01',
      endDate: '2026-05-20',
    );
    await resource.refresh();

    expect(requestedUri?.queryParameters['start_date'], '2026-05-01');
    expect(requestedUri?.queryParameters['end_date'], '2026-05-08');
  });

  test('Exoplanets datasource URL-encodes TAP query', () async {
    Uri? requestedUri;
    final dataSource = ExoplanetsRemoteDataSourceImpl(
      apiClient: ApiClient(
        client: MockClient((request) async {
          requestedUri = request.url;
          return http.Response('[]', 200);
        }),
      ),
    );

    final resource = dataSource.getExoplanets();
    await resource.refresh();

    expect(requestedUri?.host, 'exoplanetarchive.ipac.caltech.edu');
    expect(requestedUri?.path, '/TAP/sync');
    expect(requestedUri?.queryParameters['format'], 'json');
    expect(requestedUri?.queryParameters['query'], contains('from ps'));
  });
}
