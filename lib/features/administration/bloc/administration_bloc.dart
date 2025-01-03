import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/administration/models/guard_requests_model.dart';
import 'package:gate_guard/features/administration/models/resident_requests_model.dart';
import 'package:gate_guard/features/administration/models/society_guard.dart';
import 'package:gate_guard/features/administration/models/society_member.dart';
import 'package:gate_guard/features/administration/repository/administration_repository.dart';

import '../../../utils/api_error.dart';

part 'administration_event.dart';
part 'administration_state.dart';

class AdministrationBloc extends Bloc<AdministrationEvent, AdministrationState>{
  final AdministrationRepository _administrationRepository;
  AdministrationBloc({required AdministrationRepository administrationRepository}) : _administrationRepository=administrationRepository, super (AdministrationInitial()){

    on<AdminGetPendingResidentReq>((event, emit) async {
      emit(AdminGetPendingResidentReqLoading());
      try{
        final List<ResidentRequestsModel> response = await _administrationRepository.getPendingResidentRequest();
        emit(AdminGetPendingResidentReqSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetPendingResidentReqFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetPendingResidentReqFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetPendingGuardReq>((event, emit) async {
      emit(AdminGetPendingGuardReqLoading());
      try{
        final List<GuardRequestsModel> response = await _administrationRepository.getPendingGuardRequest();
        emit(AdminGetPendingGuardReqSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetPendingGuardReqFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetPendingGuardReqFailure(message: e.toString()));
        }
      }
    });

    on<AdminVerifyResident>((event, emit) async {
      emit(AdminVerifyResidentLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.verifyResidentRequest(requestId: event.requestId, user: event.user, residentStatus: event.residentStatus, );
        emit(AdminVerifyResidentSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminVerifyResidentFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminVerifyResidentFailure(message: e.toString()));
        }
      }
    });

    on<AdminVerifyGuard>((event, emit) async {
      emit(AdminVerifyGuardLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.verifyGuardRequest(requestId: event.requestId, user: event.user, guardStatus: event.guardStatus);
        emit(AdminVerifyGuardSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminVerifyGuardFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminVerifyGuardFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetSocietyMember>((event, emit) async {
      emit(AdminGetSocietyMemberLoading());
      try{
        final List<SocietyMember> response = await _administrationRepository.getAllResidents();
        emit(AdminGetSocietyMemberSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetSocietyMemberFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetSocietyMemberFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetSocietyGuard>((event, emit) async {
      emit(AdminGetSocietyGuardLoading());
      try{
        final List<SocietyGuard> response = await _administrationRepository.getAllGuards();
        emit(AdminGetSocietyGuardSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetSocietyGuardFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetSocietyGuardFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetSocietyAdmin>((event, emit) async {
      emit(AdminGetSocietyAdminLoading());
      try{
        final List<SocietyMember> response = await _administrationRepository.getAllAdmin();
        emit(AdminGetSocietyAdminSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetSocietyAdminFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetSocietyAdminFailure(message: e.toString()));
        }
      }
    });

    on<AdminCreateAdmin>((event, emit) async {
      emit(AdminCreateAdminLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.createAdmin(email: event.email);
        emit(AdminCreateAdminSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminCreateAdminFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminCreateAdminFailure(message: e.toString()));
        }
      }
    });

    on<AdminRemoveAdmin>((event, emit) async {
      emit(AdminRemoveAdminLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.removeAdmin(email: event.email);
        emit(AdminRemoveAdminSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminRemoveAdminFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminRemoveAdminFailure(message: e.toString()));
        }
      }
    });

    on<AdminRemoveResident>((event, emit) async {
      emit(AdminRemoveResidentLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.removeResident(id: event.id);
        emit(AdminRemoveResidentSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminRemoveResidentFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminRemoveResidentFailure(message: e.toString()));
        }
      }
    });

    on<AdminRemoveGuard>((event, emit) async {
      emit(AdminRemoveGuardLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.removeGuard(id: event.id);
        emit(AdminRemoveGuardSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminRemoveGuardFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminRemoveGuardFailure(message: e.toString()));
        }
      }
    });

  }
}