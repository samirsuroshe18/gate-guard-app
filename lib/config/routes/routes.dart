import 'package:flutter/material.dart';
import 'package:gate_guard/features/approval_screens/screens/delivery_approval_inside.dart';
import 'package:gate_guard/features/approval_screens/screens/delivery_approval_screen.dart';
import 'package:gate_guard/features/approval_screens/screens/verification_pending_screen.dart';
import 'package:gate_guard/features/auth/models/get_user_model.dart';
import 'package:gate_guard/features/check_in/screens/apartment_selection_screen.dart';
import 'package:gate_guard/features/guard_entry/screens/asking_cab_approval_screen.dart';
import 'package:gate_guard/features/guard_entry/screens/asking_delivery_approval_screen.dart';
import 'package:gate_guard/features/check_in/screens/block_selection_screen.dart';
import 'package:gate_guard/features/guard_entry/screens/asking_guest_approval_screen.dart';
import 'package:gate_guard/features/guard_entry/screens/asking_other_approval_screen.dart';
import 'package:gate_guard/features/guard_entry/screens/cab_approval_profile.dart';
import 'package:gate_guard/features/guard_entry/screens/cab_more_option.dart';
import 'package:gate_guard/features/guard_entry/screens/delivery_approval_profile.dart';
import 'package:gate_guard/features/guard_entry/screens/delivery_more_option.dart';
import 'package:gate_guard/features/check_in/screens/mobile_no_screen.dart';
import 'package:gate_guard/features/guard_entry/screens/guest_approval_profile.dart';
import 'package:gate_guard/features/guard_entry/screens/other_approval_profile.dart';
import 'package:gate_guard/features/guard_entry/screens/other_more_option.dart';
import 'package:gate_guard/features/guard_waiting/screens/view_resident_approval.dart';
import 'package:gate_guard/features/home/screens/admin_home_screen.dart';
import 'package:gate_guard/features/guard_profile/screens/edit_profile_screen.dart';
import 'package:gate_guard/features/home/screens/guard_home_screen.dart';
import 'package:gate_guard/features/home/screens/resident_home_screen.dart';
import 'package:gate_guard/features/invite_visitors/models/pre_approved_banner.dart';
import 'package:gate_guard/features/invite_visitors/screens/cab_company_screen.dart';
import 'package:gate_guard/features/invite_visitors/screens/delivery_company_screen.dart';
import 'package:gate_guard/features/invite_visitors/screens/manual_contacts.dart';
import 'package:gate_guard/features/invite_visitors/screens/contact_screen.dart';
import 'package:gate_guard/features/invite_visitors/screens/invite_guest_screen.dart';
import 'package:gate_guard/features/administration/screens/guard_approval_screen.dart';
import 'package:gate_guard/features/administration/screens/resident_approval_screen.dart';
import 'package:gate_guard/features/auth/screens/complete_profile_screen.dart';
import 'package:gate_guard/features/invite_visitors/screens/otp_banner.dart';

import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/guard_waiting/models/entry.dart';
import '../../features/invite_visitors/screens/other_preapprove_screen.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings){
    final args = settings.arguments;
    switch(settings.name){
      case '/':
        return _materialRoute(const SplashScreen());
      case '/login':
        return _materialRoute(const LoginScreen());
      case '/register':
        return _materialRoute(const RegisterScreen());
      case '/forgot-password':
        return _materialRoute(const ForgotPasswordScreen());
      case '/user-input':
        return _materialRoute(const CompleteProfileScreen());
      case '/resident-approval':
        return _materialRoute(const ResidentApprovalScreen());
      case '/guard-approval':
        return _materialRoute(const GuardApprovalScreen());
      case '/guard-home':
        return _materialRoute(const GuardHomeScreen());
      case '/resident-home':
        return _materialRoute(const ResidentHomeScreen());
      case '/admin-home':
        return _materialRoute(const AdminHomeScreen());
      case '/invite-guest':
        return args is Map<String, dynamic> ? _materialRoute(InviteGuestScreen(data: args,)) : _materialRoute(const InviteGuestScreen());
      case '/add-guest':
        return _materialRoute(const ManualContacts());
      case '/contact-screen':
        return args is Map<String, dynamic> ? _materialRoute(ContactsScreen(data: args,)) : _materialRoute(const ContactsScreen());
      case '/mobile-no-screen':
        return args is Map<String, dynamic> ? _materialRoute(MobileNoScreen(entryType: args['entryType'],)) : _materialRoute(const MobileNoScreen());
      case '/block-selection-screen':
        return args is Map<String, dynamic> ? _materialRoute( BlockSelectionScreen(entryType: args['entryType'],)) : _materialRoute( const BlockSelectionScreen());
      case '/apartment-selection-screen':
        return args is Map<String, dynamic> ? _materialRoute(ApartmentSelectionScreen(blockName: args['blockName'], entryType: args['entryType'],)) : _materialRoute(const ApartmentSelectionScreen());
      case '/view-resident-approval':
        return args is Entry ? _materialRoute(ViewResidentApproval(data: args,)) : _materialRoute(const ViewResidentApproval());
      case '/ask-resident-approval':
        return args is Map<String, dynamic> ? _materialRoute(AskingResidentApprovalScreen(deliveryData: args,)) : _materialRoute(const AskingResidentApprovalScreen());
      case '/delivery-approval-profile':
        return args is Map<String, dynamic> ? _materialRoute(DeliveryApprovalProfile(mobNumber: args['mobNumber'],)) : _materialRoute(const DeliveryApprovalProfile());
      case '/delivery-more-option':
        return _materialRoute( const DeliveryMoreOption());
      case '/delivery-approval-screen':
        return args is Map<String, dynamic> ? _materialRoute(DeliveryApprovalScreen(payload: args,)) : _materialRoute(const DeliveryApprovalScreen());
      case '/delivery-approval-inside':
        return args is Entry ? _materialRoute(DeliveryApprovalInside(payload: args,)) : _materialRoute(const DeliveryApprovalScreen());
      case '/verification-pending-screen':
        return _materialRoute( const VerificationPendingScreen());
      case '/otp-banner':
        return args is PreApprovedBanner ? _materialRoute( OtpBanner(data: args,)) : _materialRoute( const OtpBanner());
      case '/delivery-company-screen':
        return  _materialRoute( const DeliveryCompanyScreen());
      case '/cab-company-screen':
        return  _materialRoute( const CabCompanyScreen());
      case '/other-services-screen':
        return  _materialRoute( const OtherPreapproveScreen());
      case '/cab-approval-profile':
        return args is Map<String, dynamic> ? _materialRoute(CabApprovalProfile(mobNumber: args['mobNumber'],)) : _materialRoute( const CabApprovalProfile());
      case '/guest-approval-profile':
        return args is Map<String, dynamic> ? _materialRoute(GuestApprovalProfile(mobNumber: args['mobNumber'],)) : _materialRoute( const GuestApprovalProfile());
      case '/other-approval-profile':
        return args is Map<String, dynamic> ? _materialRoute(OtherApprovalProfile(mobNumber: args['mobNumber'],)) : _materialRoute( const OtherApprovalProfile());
      case '/cab-more-option':
        return _materialRoute( const CabMoreOption());
      case '/other-more-option':
        return _materialRoute( const OtherMoreOption());
      case '/ask-cab-approval':
        return args is Map<String, dynamic> ? _materialRoute(AskingCabApprovalScreen(deliveryData: args,)) : _materialRoute( const AskingCabApprovalScreen());
      case '/ask-other-approval':
        return args is Map<String, dynamic> ? _materialRoute(AskingOtherApprovalScreen(deliveryData: args,)) : _materialRoute( const AskingOtherApprovalScreen());
      case '/ask-guest-approval':
        return args is Map<String, dynamic> ? _materialRoute(AskingGuestApprovalScreen(deliveryData: args,)) : _materialRoute( const AskingGuestApprovalScreen());
      case '/edit-profile-screen':
        return args is GetUserModel ? _materialRoute(EditProfileScreen(data: args,)) : _materialRoute( const EditProfileScreen());
      default:
        return _materialRoute(const SplashScreen());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}