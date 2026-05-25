import 'package:flutter_test/flutter_test.dart';
import 'package:singularity/features/auth/data/models/user_model.dart';
import 'package:singularity/features/auth/domain/entities/user_entity.dart';

void main() {
  test('UserModel.fromMap defaults wallpaperCount to 0', () {
    final user = UserModel.fromMap('user-1', const {
      'name': 'Lohith',
      'email': 'lohith@example.com',
      'preferences': {'issAlerts': true},
    });

    expect(user.id, 'user-1');
    expect(user.wallpaperCount, 0);
    expect(user.preferences['issAlerts'], isTrue);
  });

  test('UserModel.fromMap accepts string createdAt values', () {
    final user = UserModel.fromMap('user-1', const {
      'createdAt': '2026-05-09T10:30:00.000',
    });

    expect(user.createdAt, DateTime(2026, 5, 9, 10, 30));
  });

  test('UserEntity.copyWith preserves and updates wallpaperCount', () {
    const user = UserEntity(
      id: 'user-1',
      email: 'lohith@example.com',
      wallpaperCount: 2,
    );

    expect(user.copyWith(name: 'Lohith').wallpaperCount, 2);
    expect(user.copyWith(wallpaperCount: 3).wallpaperCount, 3);
  });
}
