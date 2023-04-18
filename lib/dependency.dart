import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vooms/activity/pages/tutor_cubit/tutor_cubit.dart';
import 'package:vooms/activity/repository/tutor_repository.dart';
import 'package:vooms/activity/repository/tutor_data_remote_impl.dart';
import 'package:vooms/activity/repository/tutor_repository_impl.dart';
import 'package:vooms/authentication/pages/blocs/app_state_cubit/app_state_cubit.dart';
import 'package:vooms/authentication/pages/blocs/signin_cubit/sign_in_cubit.dart';
import 'package:vooms/authentication/pages/blocs/signup_cubit/sign_up_cubit.dart';
import 'package:vooms/authentication/repository/auth_repository.dart';
import 'package:vooms/authentication/repository/auth_service.dart';
import 'package:vooms/authentication/repository/auth_service_impl.dart';
import 'package:vooms/authentication/repository/image_service_impl.dart';
import 'package:vooms/authentication/repository/user_data_local_impl.dart';
import 'package:vooms/authentication/repository/user_data_remote_impl.dart';
import 'package:vooms/authentication/repository/user_repository.dart';
import 'package:vooms/authentication/repository/user_repository_impl.dart';
import 'package:vooms/chat/chat_repository/chat_service.dart';
import 'package:vooms/chat/chat_repository/chat_service_impl.dart';
import 'package:vooms/profile/pages/cubit/profile_cubit.dart';

import 'shareds/general_helper/firebase_key_constant.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);


  sl.registerLazySingleton<AuthService>(() => AuthServicesImpl(sl(), sl()));

  sl.registerLazySingleton<UserDBRemoteService>(() => UserDataRemoteImpl(sl()));

  sl.registerLazySingleton<UserDBLocalService>(() => UserDataLocalImpl(Hive.box(HiveKeyConstant.collectionUserKey)));

  
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      sl(),
      sl(),
      sl()));

  sl.registerLazySingleton<ImageService>(() => ImageServiceImpl(sl()));

  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
      sl(),
      sl(),
      sl(),
      sl()));

  sl.registerLazySingleton<TutorDBservice>(() => TutorDataRemoteImpl(sl(),
      sl()));

  sl.registerLazySingleton<TutorRepository>(() => TutorRepositoryImpl(sl())); 

  sl.registerLazySingleton<ChatService>(() => ChatServiceImpl(sl()));   

  sl.registerFactory(() => TutorCubit(sl<TutorRepository>()));
  sl.registerFactory(() => ProfileCubit(sl<UserRepository>()));
  sl.registerFactory(() => SignUpCubit(sl<AuthRepository>()));
  sl.registerFactory(() => SignInCubit(sl<AuthRepository>()));
  sl.registerFactory(() => AppStateCubit(sl<AuthRepository>()));
}
