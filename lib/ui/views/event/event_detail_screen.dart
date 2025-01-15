import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/models/event_detail_model.dart';
import 'package:event_any_where_app/ui/viewmodels/event/event_detail_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/event/event_participation_viewmodel.dart';
import 'package:event_any_where_app/ui/widgets/tabs/event_overview_tab.dart';
import 'package:event_any_where_app/ui/widgets/tabs/event_session_tab.dart';
import 'package:event_any_where_app/ui/widgets/tabs/event_speaker_tab.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    final eventViewModel =
        Provider.of<EventDetailViewModel>(context, listen: false);
    final participationViewModel =
        Provider.of<EventParticipationViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await eventViewModel.fetchEvent(widget.eventId);
      await participationViewModel.checkJoinStatus(widget.eventId);
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventDetailViewModel>(context);
    final participationViewModel =
        Provider.of<EventParticipationViewModel>(context);
    final isInteractionDisabled =
        !participationViewModel.hasJoined && !participationViewModel.isLoading;

    return Scaffold(
      backgroundColor: MyTheme.backgroundcolor,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          _buildBodyContent(eventViewModel, isInteractionDisabled),
          if (isInteractionDisabled) _buildModalBarrier(),
          if (isInteractionDisabled)
            _buildJoinEventButton(context, participationViewModel),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(isInteractionDisabled),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: const Text('Event Details', style: AppTextStyles.appbarText),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBodyContent(
      EventDetailViewModel eventViewModel, bool isInteractionDisabled) {
    if (eventViewModel.isLoading) {
      return Center(
          child: CircularProgressIndicator(color: MyTheme.primaryColor));
    }

    if (eventViewModel.event == null) {
      return const Center(
          child:
              Text('Event not found', style: TextStyle(color: Colors.white)));
    }

    return _buildTabContent(eventViewModel.event!);
  }

  Widget _buildModalBarrier() {
    return const ModalBarrier(dismissible: false, color: Colors.transparent);
  }

  Widget _buildJoinEventButton(BuildContext context,
      EventParticipationViewModel participationViewModel) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyTheme.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        onPressed: () async {
          await participationViewModel.joinEvent(widget.eventId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AwesomeSnackbarContent(
                title: 'Success!',
                message: 'Participate in the event successfully!',
                contentType: ContentType.success,
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                'Join Event',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            const Image(image: AssetImage('assets/icons/right_arrow.png')),
          ],
        ),
      ),
    );
  }

  IgnorePointer _buildBottomNavigationBar(bool isInteractionDisabled) {
    return IgnorePointer(
      ignoring: isInteractionDisabled,
      child: BottomNavigationBar(
        backgroundColor: MyTheme.bottomBarBgColor,
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        selectedItemColor: MyTheme.primaryColor,
        unselectedItemColor: MyTheme.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Session'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Speaker'),
        ],
      ),
    );
  }

  Widget _buildTabContent(EventDetail event) {
    switch (_selectedIndex) {
      case 0:
        return EventOverviewTab(event: event);
      case 1:
        return EventSessionTab(sessions: event.sessions);
      case 2:
        return EventSpeakerTab(speakers: event.speakers);
      default:
        return const Center(
            child: Text('Content not available',
                style: TextStyle(color: Colors.white)));
    }
  }
}
