import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/ui/viewmodels/account/change_password_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/event/event_management_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/event/event_participation_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/event/event_search_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/event/event_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/home/filter_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/home/home_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/notification/notification_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/account/profile_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/AI_recommendation/recommend_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/account/reset_password_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/session/session_detail_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/session/session_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/account/signup_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/event/speaker_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/event/update_event_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/session/update_session_viewmodel.dart';
import 'package:event_any_where_app/ui/views/event/update_event_screen.dart';
import '../core/constants/app_routers.dart';
import 'ui/viewmodels/account/signin_viewmodel.dart';
import 'ui/viewmodels/event/event_detail_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => SignInViewModel()),
        ChangeNotifierProvider(create: (_) => EventDetailViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => ResetPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => EventViewModel()),
        ChangeNotifierProvider(create: (_) => EventManagementViewModel()),
        ChangeNotifierProvider(create: (_) => SessionViewModel()),
        ChangeNotifierProvider(create: (_) => SessionDetailViewModel()),
        ChangeNotifierProvider(create: (_) => SpeakerViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateSessionViewmodel()),
        ChangeNotifierProvider(create: (_) => UpdateEventViewModel()),
        ChangeNotifierProvider(create: (_) => EventSearchViewModel()),
        ChangeNotifierProvider(create: (_) => FilterViewModel()),
        ChangeNotifierProvider(create: (_) => RecommendViewModel()),
        ChangeNotifierProvider(create: (_) => EventParticipationViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
