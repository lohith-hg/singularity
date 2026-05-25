import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/features/auth/domain/entities/user_entity.dart';
import 'package:singularity/features/profile/presentation/pages/profile_page.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('ProfileStatsRow renders saved, wallpaper, and alert counts', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileStatsRow(
            savedCount: 2,
            user: UserEntity(
              id: 'user-1',
              wallpaperCount: 4,
              preferences: {
                'issAlerts': true,
                'solarAlerts': false,
                'neoAlerts': false,
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('2'), findsOneWidget);
    expect(find.text('SAVED'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('WALLPAPERS'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('ALERTS'), findsOneWidget);
  });
}
