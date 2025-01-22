import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import '../../viewmodels/event/event_management_viewmodel.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:intl/intl.dart';

class EventManagementScreen extends StatefulWidget {
  final String eventId;

  const EventManagementScreen({super.key, required this.eventId});

  @override
  _EventManagementScreenState createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  late EventManagementViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EventManagementViewModel();
    _viewModel.fetchEventDetails(widget.eventId);
  }

  String formatEventDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedDate;
  }

  String formatEventTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventManagementViewModel>(
      create: (_) => _viewModel,
      child: Consumer<EventManagementViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Event Management"),
                backgroundColor: MyTheme.primaryColor,
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (viewModel.isError) {
            return Scaffold(
              backgroundColor: MyTheme.backgroundcolor,
              appBar: AppBar(
                title: Text("Event Management"),
                backgroundColor: MyTheme.backgroundcolor,
              ),
              body: Center(child: Text(viewModel.errorMessage)),
            );
          }

          if (viewModel.event == null) {
            return Scaffold(
              backgroundColor: MyTheme.backgroundcolor,
              appBar: AppBar(
                title: Text("Event Management"),
                backgroundColor: MyTheme.backgroundcolor,
              ),
              body: Center(child: Text('Event not found')),
            );
          }

          final event = viewModel.event!;

          return Scaffold(
            backgroundColor: MyTheme.backgroundcolor,
            appBar: AppBar(
              title: Text("Event Management"),
              titleTextStyle: AppTextStyles.appbarText,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  GoRouter.of(context).pop();
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          width: 160,
                          height: 110,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: Image.network(
                            event.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: MyTheme.white,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: const Color.fromARGB(255, 244, 139, 94),
                                size: 22,
                              ),
                              SizedBox(width: 4),
                              Text(
                                formatEventDate(event.date),
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 138, 138, 138),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: const Color.fromARGB(255, 244, 139, 94),
                                size: 22,
                              ),
                              SizedBox(width: 4),
                              Text(
                                formatEventTime(event.date),
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 138, 138, 138),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: const Color.fromARGB(255, 244, 139, 94),
                                size: 22,
                              ),
                              SizedBox(width: 4),
                              Text(
                                event.location,
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 138, 138, 138),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 295,
                        child: ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context).push('/event/${event.id}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Text(
                                  "View Preview",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 20),
                              Flexible(
                                  flex: 1,
                                  child: Image.asset(
                                      'assets/icons/right_arrow.png'))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Center(
                        child: PopupMenuButton<String>(
                          icon: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: MyTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.more_horiz,
                              size: 30,
                              color: MyTheme.primaryColor,
                            ),
                          ),
                          onSelected: (String value) async {
                            if (value == 'Delete') {
                              final confirmDelete = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        const Color.fromARGB(255, 6, 3, 25),
                                    title: Text(
                                      'Confirm Deletion',
                                      style: TextStyle(
                                        color: MyTheme.white,
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete this event?',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: MyTheme.white,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: MyTheme.primaryColor),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: MyTheme.primaryColor),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmDelete == true) {
                                await _viewModel.deleteEvent(event.id);
                                final snackBar = SnackBar(
                                  content: AwesomeSnackbarContent(
                                    title: _viewModel.isDeleted
                                        ? 'Success!'
                                        : 'Failure!',
                                    message: _viewModel.isDeleted
                                        ? 'Event deleted successfully'
                                        : 'Failed to delete event',
                                    contentType: _viewModel.isDeleted
                                        ? ContentType.success
                                        : ContentType.failure,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                if (_viewModel.isDeleted) {
                                  GoRouter.of(context).pop();
                                }
                              }
                            }
                          },
                          color: const Color.fromARGB(255, 11, 11, 19),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<String>(
                              value: 'AddCalendar',
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_month,
                                      color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add to Calendar',
                                    style: AppTextStyles.body,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete Event',
                                    style: AppTextStyles.body,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
