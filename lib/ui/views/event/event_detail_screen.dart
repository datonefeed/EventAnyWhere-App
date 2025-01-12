import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:event_any_where_app/models/event_detail_model.dart';
import 'package:event_any_where_app/ui/viewmodels/event/event_detail_viewmodel.dart';
import 'package:event_any_where_app/ui/viewmodels/event/event_participation_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/ui/widgets/tabs/event_overview_tab.dart';
import 'package:event_any_where_app/ui/widgets/tabs/event_session_tab.dart';
import 'package:event_any_where_app/ui/widgets/tabs/event_speaker_tab.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  EventDetailScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final eventViewModel =
        Provider.of<EventDetailViewModel>(context, listen: false);
    final participationViewModel =
        Provider.of<EventParticipationViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Lấy thông tin sự kiện
      await eventViewModel.fetchEvent(widget.eventId);

      // Kiểm tra trạng thái tham gia
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

    final isInteractionDisabled = !participationViewModel.hasJoined &&
        !participationViewModel
            .isLoading; // Điều kiện để chặn toàn bộ giao diện

    return Scaffold(
      backgroundColor: MyTheme.backgroundcolor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Event Details',
          style: AppTextStyles.appbarText,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Nội dung chính của màn hình
          eventViewModel.isLoading
              ? Center(
                  child: CircularProgressIndicator(color: MyTheme.primaryColor))
              : eventViewModel.event == null
                  ? Center(
                      child: Text(
                        'Event not found',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : _buildTabContent(eventViewModel.event!),

          // ModalBarrier để chặn tương tác
          if (isInteractionDisabled)
            ModalBarrier(
              dismissible: false, // Không thể đóng barrier bằng cách bấm ngoài
              color: Colors.transparent, // Không hiển thị màu chắn
            ),

          // Nút Join Event
          if (isInteractionDisabled)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                margin: EdgeInsets.symmetric(horizontal: 46),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 238, 109, 10)
                          .withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  onPressed: () async {
                    await participationViewModel.joinEvent(widget.eventId);
                    final snackBar = SnackBar(
                      content: AwesomeSnackbarContent(
                        title: 'Success!',
                        message: 'Participate in the event successfully!',
                        contentType: ContentType.success,
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 90),
                      Expanded(
                        child: Text(
                          'Join Event',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Image(image: AssetImage('assets/icons/right_arrow.png')),
                      SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: IgnorePointer(
        ignoring: isInteractionDisabled, // Chặn tương tác nếu điều kiện đúng
        child: Container(
          height: 70,
          child: BottomNavigationBar(
            backgroundColor: MyTheme.bottomBarBgColor,
            currentIndex: _selectedIndex,
            onTap: _onTabSelected,
            selectedItemColor: MyTheme.primaryColor,
            unselectedItemColor: MyTheme.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'Overview',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule),
                label: 'Session',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Speaker',
              ),
            ],
          ),
        ),
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
        return Center(
            child: Text(
          'Content not available',
          style: TextStyle(color: Colors.white),
        ));
    }
  }
}
