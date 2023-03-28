import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/cosmo_daily/bindings/cosmo_daily_binding.dart';
import '../modules/cosmo_daily/views/cosmo_daily_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/explore/views/explore_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/sky_stories/bindings/sky_stories_binding.dart';
import '../modules/sky_stories/views/sky_stories_view.dart';
import '../modules/vintage_space/bindings/vintage_space_binding.dart';
import '../modules/vintage_space/views/vintage_space_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const HOME = Routes.HOME;
  static const AUTH = Routes.AUTH;
  static const COSMO_DAILY = Routes.COSMO_DAILY;
  static const SKY_STORIES = Routes.SKY_STORIES;
  static const VINTAGE_SPACE = Routes.VINTAGE_SPACE;
  static const EXPLORE = Routes.EXPLORE;
  static const PROFILE = Routes.PROFILE;

  static final routes = [
    GetPage(
        participatesInRootNavigator: true,
        name: '/',
        page: () => GetRouterOutlet.builder(
              builder: (BuildContext context, GetDelegate delegate,
                  GetNavConfig? current) {
                return GetRouterOutlet(
                  initialRoute: FirebaseAuth.instance.currentUser != null
                      ? _Paths.HOME
                      : _Paths.AUTH,
                );
              },
            ),
        children: [
          GetPage(
            name: _Paths.HOME,
            page: () => const HomeView(),
            binding: HomeBinding(),
          ),
          GetPage(
            name: _Paths.AUTH,
            page: () => AuthView(),
            binding: AuthBinding(),
          ),
          GetPage(
            name: _Paths.COSMO_DAILY,
            page: () => const CosmoDailyView(),
            binding: CosmoDailyBinding(),
          ),
          GetPage(
            name: _Paths.SKY_STORIES,
            page: () => SkyStoriesView(),
            binding: SkyStoriesBinding(),
          ),
          GetPage(
            name: _Paths.VINTAGE_SPACE,
            page: () => VintageSpaceView(),
            binding: VintageSpaceBinding(),
          ),
          GetPage(
            name: _Paths.EXPLORE,
            page: () => const ExploreView(),
            binding: ExploreBinding(),
          ),
          GetPage(
            name: _Paths.PROFILE,
            page: () => ProfileView(),
            binding: ProfileBinding(),
          ),
        ])
  ];
}
