import 'package:get_it/get_it.dart';

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
import 'features/sky_stories/data/repositories/sky_stories_repository_impl.dart';
import 'features/sky_stories/domain/repositories/sky_stories_repository.dart';
import 'features/sky_stories/domain/usecases/get_sky_stories.dart';
import 'features/sky_stories/presentation/bloc/sky_stories_bloc.dart';
import 'features/vintage_space/data/datasources/nasa_images_remote_datasource.dart';
import 'features/vintage_space/data/repositories/nasa_images_repository_impl.dart';
import 'features/vintage_space/domain/repositories/nasa_images_repository.dart';
import 'features/vintage_space/domain/usecases/get_vintage_images.dart';
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
import 'features/profile/domain/usecases/update_user_profile.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

// Global service locator — sl<SomeType>() returns a registered instance.
// Call initDependencies() once before runApp().
// Registration order: datasources → repositories → usecases → blocs.
final sl = GetIt.instance;

Future<void> initDependencies() async {
  _registerExploreFeature();
  _registerCosmoDailyFeature();
  _registerSkyStoriesFeature();
  _registerVintageSpaceFeature();
  _registerProfileFeature();
  _registerAuthFeature();
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
  sl.registerFactory(
    () => ExploreBloc(getPlanets: sl(), getArticles: sl()),
  );
}

void _registerCosmoDailyFeature() {
  sl.registerLazySingleton<ApodRemoteDataSource>(
    () => ApodRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ApodRepository>(
    () => ApodRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetApodPictures(sl()));
  sl.registerFactory(
    () => CosmoDailyBloc(getApodPictures: sl()),
  );
}

void _registerSkyStoriesFeature() {
  // Reuses ApodRemoteDataSource already registered by Cosmo Daily
  sl.registerLazySingleton<SkyStoriesRepository>(
    () => SkyStoriesRepositoryImpl(sl<ApodRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetSkyStories(sl()));
  sl.registerFactory(
    () => SkyStoriesBloc(getSkyStories: sl()),
  );
}

void _registerVintageSpaceFeature() {
  sl.registerLazySingleton<NasaImagesRemoteDataSource>(
    () => NasaImagesRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<NasaImagesRepository>(
    () => NasaImagesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetVintageImages(sl()));
  sl.registerFactory(
    () => VintageSpaceBloc(getVintageImages: sl()),
  );
}

void _registerAuthFeature() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  // AuthRepositoryImpl needs ProfileRepository (already registered above).
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl(), profileRepository: sl()),
  );
  sl.registerLazySingleton(() => GetAuthState(sl()));
  sl.registerLazySingleton(() => SignInWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => SignUpWithEmailUseCase(
      authRepository: sl(), profileRepository: sl()));
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerFactory(() => AuthBloc(
        getAuthState: sl(),
        signInWithEmail: sl(),
        signUpWithEmail: sl(),
        signInWithGoogle: sl(),
        signOut: sl(),
        resetPassword: sl(),
      ));
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
  sl.registerFactory(
    () => ProfileBloc(getUserProfile: sl(), updateUserProfile: sl()),
  );
}
