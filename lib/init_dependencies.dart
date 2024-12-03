import 'package:gate_guard/features/administration/bloc/administration_bloc.dart';
import 'package:gate_guard/features/administration/repository/administration_repository.dart';
import 'package:gate_guard/features/check_in/bloc/check_in_bloc.dart';
import 'package:gate_guard/features/check_in/repository/check_in_repository.dart';
import 'package:gate_guard/features/guard_entry/bloc/guard_entry_bloc.dart';
import 'package:gate_guard/features/guard_entry/repository/guard_entry_repository.dart';
import 'package:gate_guard/features/guard_exit/bloc/guard_exit_bloc.dart';
import 'package:gate_guard/features/guard_exit/repository/guard_exit_repository.dart';
import 'package:gate_guard/features/guard_profile/bloc/guard_profile_bloc.dart';
import 'package:gate_guard/features/guard_profile/repository/guard_profile_repository.dart';
import 'package:gate_guard/features/guard_waiting/bloc/guard_waiting_bloc.dart';
import 'package:gate_guard/features/guard_waiting/repository/guard_waiting_repository.dart';
import 'package:gate_guard/features/invite_visitors/bloc/invite_visitors_bloc.dart';
import 'package:gate_guard/features/invite_visitors/repository/invite_visitors_repository.dart';
import 'package:gate_guard/features/my_visitors/bloc/my_visitors_bloc.dart';
import 'package:gate_guard/features/my_visitors/repository/my_visitors_repository.dart';
import 'package:gate_guard/features/setting/bloc/setting_bloc.dart';
import 'package:gate_guard/features/setting/repository/setting_repository.dart';
import 'package:get_it/get_it.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/repository/auth_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies()async {
  _initAuth();
  _initAdministration();
  _initCheckIn();
  _initGuardEntry();
  _initGuardWaiting();
  _initGuardExit();
  _initInviteVisitor();
  _initMyVisitor();
  _initGuardProfile();
  _initSetting();
}

void _initAuth(){
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepository());
  serviceLocator.registerLazySingleton(()=> AuthBloc(authRepository: serviceLocator()));
}

void _initAdministration(){
  serviceLocator.registerLazySingleton<AdministrationRepository>(() => AdministrationRepository());
  serviceLocator.registerLazySingleton(()=> AdministrationBloc(administrationRepository: serviceLocator()));
}

void _initCheckIn(){
  serviceLocator.registerLazySingleton<CheckInRepository>(() => CheckInRepository());
  serviceLocator.registerLazySingleton(()=> CheckInBloc(checkInRepository: serviceLocator()));
}

void _initGuardEntry(){
  serviceLocator.registerLazySingleton<GuardEntryRepository>(() => GuardEntryRepository());
  serviceLocator.registerLazySingleton(()=> GuardEntryBloc(guardEntryRepository: serviceLocator()));
}

void _initGuardWaiting(){
  serviceLocator.registerLazySingleton<GuardWaitingRepository>(() => GuardWaitingRepository());
  serviceLocator.registerLazySingleton(()=> GuardWaitingBloc(guardWaitingRepository: serviceLocator()));
}

void _initGuardExit(){
  serviceLocator.registerLazySingleton<GuardExitRepository>(() => GuardExitRepository());
  serviceLocator.registerLazySingleton(()=> GuardExitBloc(guardExitRepository: serviceLocator()));
}

void _initInviteVisitor(){
  serviceLocator.registerLazySingleton<InviteVisitorsRepository>(() => InviteVisitorsRepository());
  serviceLocator.registerLazySingleton(()=> InviteVisitorsBloc(inviteVisitorsRepository: serviceLocator()));
}

void _initMyVisitor(){
  serviceLocator.registerLazySingleton<MyVisitorsRepository>(() => MyVisitorsRepository());
  serviceLocator.registerLazySingleton(()=> MyVisitorsBloc(myVisitorsRepository: serviceLocator()));
}

void _initGuardProfile(){
  serviceLocator.registerLazySingleton<GuardProfileRepository>(() => GuardProfileRepository());
  serviceLocator.registerLazySingleton(()=> GuardProfileBloc(guardProfileRepository: serviceLocator()));
}

void _initSetting(){
  serviceLocator.registerLazySingleton<SettingRepository>(() => SettingRepository());
  serviceLocator.registerLazySingleton(()=> SettingBloc(settingRepository: serviceLocator()));
}