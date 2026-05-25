import 'package:get_it/get_it.dart';

import 'core/services/cache_service.dart';
import 'core/services/onboarding_service.dart';
import 'features/cosmo_daily/data/datasources/apod_remote_datasource.dart';
import 'features/cosmo_daily/data/repositories/apod_repository_impl.dart';
import 'features/cosmo_daily/domain/repositories/apod_repository.dart';
import 'features/cosmo_daily/domain/usecases/get_apod_pictures.dart';
import 'features/cosmo_daily/presentation/bloc/cosmo_daily_bloc.dart';
import 'features/explore/data/datasources/explore_local_datasource.dart';
import 'features/explore/data/repositories/explore_repository_impl.dart';
import 'features/explore/domain/repositories/explore_repository.dart';
import 'features/explore/domain/usecases/get_articles.dart';
import 'features/explore/domain/usecases/get_planets.dart';
import 'features/explore/presentation/bloc/explore_bloc.dart';
import 'features/saved/data/datasources/saved_remote_datasource.dart';
import 'features/saved/data/repositories/saved_repository_impl.dart';
import 'features/saved/domain/repositories/saved_repository.dart';
import 'features/saved/domain/usecases/get_saved_items.dart';
import 'features/saved/domain/usecases/save_apod.dart';
import 'features/saved/domain/usecases/unsave_apod.dart';
import 'features/saved/presentation/bloc/saved_bloc.dart';
import 'features/vintage_space/data/datasources/nasa_images_remote_datasource.dart';
import 'features/vintage_space/data/repositories/nasa_images_repository_impl.dart';
import 'features/vintage_space/domain/repositories/nasa_images_repository.dart';
import 'features/vintage_space/domain/usecases/get_vintage_images.dart';
import 'features/vintage_space/domain/usecases/search_nasa_images.dart';
import 'features/vintage_space/presentation/bloc/vintage_space_bloc.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_auth_state.dart';
import 'features/auth/domain/usecases/reset_password.dart';
import 'features/auth/domain/usecases/sign_in_email.dart';
import 'features/auth/domain/usecases/sign_in_google.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/sign_up_email.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_user_profile.dart';
import 'features/profile/domain/usecases/increment_wallpaper_count.dart';
import 'features/profile/domain/usecases/update_user_profile.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
// New features
import 'features/mars_rover/data/datasources/mars_rover_remote_datasource.dart';
import 'features/mars_rover/data/repositories/mars_rover_repository_impl.dart';
import 'features/mars_rover/domain/repositories/mars_rover_repository.dart';
import 'features/mars_rover/domain/usecases/get_rover_photos.dart';
import 'features/mars_rover/presentation/bloc/mars_rover_bloc.dart';
import 'features/epic/data/datasources/epic_remote_datasource.dart';
import 'features/epic/data/repositories/epic_repository_impl.dart';
import 'features/epic/domain/repositories/epic_repository.dart';
import 'features/epic/domain/usecases/get_epic_images.dart';
import 'features/epic/presentation/bloc/epic_bloc.dart';
import 'features/iss_tracker/data/datasources/iss_tracker_remote_datasource.dart';
import 'features/iss_tracker/data/repositories/iss_tracker_repository_impl.dart';
import 'features/iss_tracker/domain/repositories/iss_tracker_repository.dart';
import 'features/iss_tracker/domain/usecases/get_iss_position.dart';
import 'features/iss_tracker/presentation/bloc/iss_tracker_bloc.dart';
import 'features/neo/data/datasources/neo_remote_datasource.dart';
import 'features/neo/data/repositories/neo_repository_impl.dart';
import 'features/neo/domain/repositories/neo_repository.dart';
import 'features/neo/domain/usecases/get_neos.dart';
import 'features/neo/presentation/bloc/neo_bloc.dart';
import 'features/exoplanets/data/datasources/exoplanets_remote_datasource.dart';
import 'features/exoplanets/data/repositories/exoplanets_repository_impl.dart';
import 'features/exoplanets/domain/repositories/exoplanets_repository.dart';
import 'features/exoplanets/domain/usecases/get_exoplanets.dart';
import 'features/exoplanets/presentation/bloc/exoplanets_bloc.dart';
import 'features/donki/data/datasources/donki_remote_datasource.dart';
import 'features/donki/data/repositories/donki_repository_impl.dart';
import 'features/donki/domain/repositories/donki_repository.dart';
import 'features/donki/domain/usecases/get_space_weather_events.dart';
import 'features/donki/presentation/bloc/donki_bloc.dart';

// Global service locator — sl<SomeType>() returns a registered instance.
// Call initDependencies() once before runApp().
// Registration order: datasources → repositories → usecases → blocs.
final sl = GetIt.instance;

Future<void> initDependencies() async {
  final cacheService = CacheService();
  await cacheService.init();
  sl.registerSingleton<CacheService>(cacheService);

  sl.registerLazySingleton(() => OnboardingService());
  _registerExploreFeature();
  _registerCosmoDailyFeature();
  _registerVintageSpaceFeature();
  _registerProfileFeature();
  _registerAuthFeature();
  _registerMarsRoverFeature();
  _registerEpicFeature();
  _registerIssTrackerFeature();
  _registerNeoFeature();
  _registerExoplanetsFeature();
  _registerDonkiFeature();
  _registerSavedFeature();
}

void _registerExploreFeature() {
  sl.registerLazySingleton<ExploreLocalDataSource>(
    () => ExploreLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<ExploreRepository>(
    () => ExploreRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetPlanets(sl()));
  sl.registerLazySingleton(() => GetArticles(sl()));
  sl.registerFactory(() => ExploreBloc(getPlanets: sl(), getArticles: sl()));
}

void _registerCosmoDailyFeature() {
  sl.registerLazySingleton<ApodRemoteDataSource>(
    () => const ApodRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ApodRepository>(() => ApodRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetApodPictures(sl()));
  sl.registerFactory(() => CosmoDailyBloc(getApodPictures: sl()));
}

void _registerVintageSpaceFeature() {
  sl.registerLazySingleton<NasaImagesRemoteDataSource>(
    () => const NasaImagesRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<NasaImagesRepository>(
    () => NasaImagesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetVintageImages(sl()));
  sl.registerLazySingleton(() => SearchNasaImages(sl()));
  sl.registerFactory(
    () => VintageSpaceBloc(getVintageImages: sl(), searchNasaImages: sl()),
  );
}

void _registerAuthFeature() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl(), profileRepository: sl()),
  );
  sl.registerLazySingleton(() => GetAuthState(sl()));
  sl.registerLazySingleton(() => SignInWithEmailUseCase(sl()));
  sl.registerLazySingleton(
    () => SignUpWithEmailUseCase(authRepository: sl(), profileRepository: sl()),
  );
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerFactory(
    () => AuthBloc(
      getAuthState: sl(),
      signInWithEmail: sl(),
      signUpWithEmail: sl(),
      signInWithGoogle: sl(),
      signOut: sl(),
      resetPassword: sl(),
    ),
  );
}

void _registerProfileFeature() {
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton(() => IncrementWallpaperCount(sl()));
  sl.registerFactory(
    () => ProfileBloc(getUserProfile: sl(), updateUserProfile: sl()),
  );
}

void _registerMarsRoverFeature() {
  sl.registerLazySingleton<MarsRoverRemoteDataSource>(
    () => MarsRoverRemoteDataSourceImpl(cacheService: sl()),
  );
  sl.registerLazySingleton<MarsRoverRepository>(
    () => MarsRoverRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetRoverPhotos(sl()));
  sl.registerFactory(() => MarsRoverBloc(getRoverPhotos: sl()));
}

void _registerEpicFeature() {
  sl.registerLazySingleton<EpicRemoteDataSource>(
    () => const EpicRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<EpicRepository>(() => EpicRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetEpicImages(sl()));
  sl.registerFactory(() => EpicBloc(getEpicImages: sl()));
}

void _registerIssTrackerFeature() {
  sl.registerLazySingleton<IssTrackerRemoteDataSource>(
    () => const IssTrackerRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<IssTrackerRepository>(
    () => IssTrackerRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetIssPosition(sl()));
  sl.registerFactory(() => IssTrackerBloc(getIssPosition: sl()));
}

void _registerNeoFeature() {
  sl.registerLazySingleton<NeoRemoteDataSource>(
    () => const NeoRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<NeoRepository>(() => NeoRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetNeos(sl()));
  sl.registerFactory(() => NeoBloc(getNeos: sl()));
}

void _registerExoplanetsFeature() {
  sl.registerLazySingleton<ExoplanetsRemoteDataSource>(
    () => const ExoplanetsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ExoplanetsRepository>(
    () => ExoplanetsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetExoplanets(sl()));
  sl.registerFactory(() => ExoplanetsBloc(getExoplanets: sl()));
}

void _registerDonkiFeature() {
  sl.registerLazySingleton<DonkiRemoteDataSource>(
    () => const DonkiRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<DonkiRepository>(() => DonkiRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetSpaceWeatherEvents(sl()));
  sl.registerFactory(() => DonkiBloc(getSpaceWeatherEvents: sl()));
}

void _registerSavedFeature() {
  sl.registerLazySingleton<SavedRemoteDataSource>(
    () => SavedRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<SavedRepository>(() => SavedRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetSavedItems(sl()));
  sl.registerLazySingleton(() => SaveApod(sl()));
  sl.registerLazySingleton(() => UnsaveApod(sl()));
  sl.registerFactory(
    () => SavedBloc(getSavedItems: sl(), saveApod: sl(), unsaveApod: sl()),
  );
}
