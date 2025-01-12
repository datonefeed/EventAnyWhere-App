import 'package:event_any_where_app/ui/views/event/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:event_any_where_app/models/event_model.dart';
import 'package:event_any_where_app/models/speaker_model.dart';
import 'package:event_any_where_app/ui/views/auth/becoming_organizer_screen.dart';
import 'package:event_any_where_app/ui/views/auth/change_password_screen.dart';
import 'package:event_any_where_app/ui/views/auth/edit_profile_screen.dart';
import 'package:event_any_where_app/ui/views/auth/reset_password_screen.dart';
import 'package:event_any_where_app/ui/views/entry_point.dart';
import 'package:event_any_where_app/ui/views/auth/profile_screen.dart';
import 'package:event_any_where_app/ui/views/session/add_session_screen.dart';
import 'package:event_any_where_app/ui/views/session/add_speaker_screen.dart';
import 'package:event_any_where_app/ui/views/event/customize_screen.dart';
import 'package:event_any_where_app/ui/views/event/event_details_screen.dart';
import 'package:event_any_where_app/ui/views/event/event_list_screen.dart';
import 'package:event_any_where_app/ui/views/event/preview_screen.dart';
import 'package:event_any_where_app/ui/views/AI_recommendation/recommend_screen.dart';
import 'package:event_any_where_app/ui/views/event/review_and_send_screen.dart';
import 'package:event_any_where_app/ui/views/session/session_detail_screen.dart';
import 'package:event_any_where_app/ui/views/session/session_list_screen.dart';
import 'package:event_any_where_app/ui/views/event/speaker_detail_screen.dart';
import 'package:event_any_where_app/ui/views/event/upcoming_list_event.dart';
import 'package:event_any_where_app/ui/views/event/update_event_screen.dart';
import 'package:event_any_where_app/ui/views/session/update_session_screen.dart';
import 'package:event_any_where_app/ui/views/event/event_management_screen.dart';
import 'package:event_any_where_app/ui/views/notification/notification_screen.dart';
import 'package:event_any_where_app/ui/views/home/search_results_screen.dart';
import '../../ui/views/infomation/onboarding1_screen.dart';
import '../../ui/views/infomation/onboarding2_screen.dart';
import '../../ui/views/infomation/onboarding3_screen.dart';
import '../../ui/views/auth/signin_screen.dart';
import '../../ui/views/auth/signup_screen.dart';
import '../../ui/views/home/home_screen.dart';
import '../../ui/views/event/event_detail_screen.dart';
import '../../ui/views/event/event_session_detail_screen.dart';
import 'package:event_any_where_app/models/session_model.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding1',
    routes: [
      GoRoute(
        path: '/onboarding1',
        builder: (context, state) => Onboarding1Screen(),
      ),
      GoRoute(
        path: '/onboarding2',
        builder: (context, state) => Onboarding2Screen(),
      ),
      GoRoute(
        path: '/onboarding3',
        builder: (context, state) => Onboarding3Screen(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => SigninScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/event/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return EventDetailScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: '/sessionDetail',
        builder: (context, state) {
          final session = state.extra as Session;
          return SessionDetailScreen(session: session);
        },
      ),
      GoRoute(
        path: '/entryPoint',
        builder: (context, state) => EntryPoint(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileScreen(),
      ),
      GoRoute(
        path: '/editProfile',
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: '/notification',
        builder: (context, state) => NotificationScreen(),
      ),
      GoRoute(
        path: '/changePassword',
        builder: (context, state) => ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/resetPassword',
        builder: (context, state) => ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/becomingOrganizer',
        builder: (context, state) => BecomingOrganizerScreen(),
      ),
      GoRoute(
        path: '/customize',
        builder: (context, state) => CustomizeScreen(),
      ),
      GoRoute(
        path: '/eventDetails',
        builder: (context, state) => EventDetailsScreen(),
      ),
      GoRoute(
        path: '/preview',
        builder: (context, state) => PreviewScreen(),
      ),
      GoRoute(
        path: '/reviewAndSend',
        builder: (context, state) => ReviewAndSendScreen(),
      ),
      GoRoute(
        path: '/myEventList',
        builder: (context, state) => EventListScreen(),
      ),
      GoRoute(
        path: '/eventManagement/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return EventManagementScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: '/sessionList/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return SessionListScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: '/addSession/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return AddSessionScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: '/session-detail',
        builder: (context, state) {
          final session = state.extra as Map<String, dynamic>;
          return MySessionDetailScreen(session: session);
        },
      ),
      GoRoute(
        path: '/addSpeaker/:id',
        builder: (context, state) {
          final sessionId = state.pathParameters['id']!;
          return AddSpeakerScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: '/updateSession',
        builder: (context, state) {
          final session = state.extra as Map<String, dynamic>;
          return UpdateSessionScreen(session: session);
        },
      ),
      GoRoute(
        path: '/updateEvent',
        builder: (context, state) {
          final event = state.extra as EventModel;
          return UpdateEventScreen(event: event);
        },
      ),
      GoRoute(
        path: '/search-results',
        builder: (context, state) {
          final keyword = state.extra as String;
          return SearchResultsScreen(keyword: keyword);
        },
      ),
      GoRoute(
        path: '/recommend',
        builder: (context, state) => RecommendScreen(),
      ),
      GoRoute(
        path: '/speakerDetail',
        builder: (context, state) {
          final speaker = state.extra as Speaker;
          return SpeakerDetailScreen(speaker: speaker);
        },
      ),
      GoRoute(
        path: '/upcomingEventList',
        builder: (context, state) => UpcomingListEvent(),
      ),
    ],
  );
}
