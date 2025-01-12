import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import '../../viewmodels/session/session_viewmodel.dart';
import 'package:intl/intl.dart';

class SessionListScreen extends StatefulWidget {
  final String eventId;

  const SessionListScreen({required this.eventId});

  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SessionViewModel>(context, listen: false)
          .fetchSessions(widget.eventId);
    });
  }

  String formatEventTime(String date) {
    // Chuyển đổi date thành đối tượng DateTime
    DateTime dateTime = DateTime.parse(date);

    // Định dạng giờ và phút cùng với AM/PM
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionViewModel>(
      builder: (context, sessionViewModel, child) {
        if (sessionViewModel.isLoading) {
          return Scaffold(
            appBar: AppBar(title: Text('My Session')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (sessionViewModel.errorMessage.isNotEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text('My Session')),
            body:
                Center(child: Text('Error: ${sessionViewModel.errorMessage}')),
          );
        }

        if (sessionViewModel.sessions.isEmpty) {
          return Scaffold(
            backgroundColor: MyTheme.backgroundcolor,
            appBar: AppBar(
              title: Text(
                'My Session',
                style: AppTextStyles.appbarText,
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  context.pop();
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).push('/addSession/${widget.eventId}');
                  },
                  child: Row(
                    children: [
                      Text(
                        "Add",
                        style: TextStyle(
                            color: MyTheme.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        Icons.add,
                        color: MyTheme.primaryColor,
                      )
                    ],
                  ),
                ),
              ],
              backgroundColor: MyTheme.backgroundcolor,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/ic_no_session_found.png',
                  ),
                ],
              ),
            ),
          );
        }

        // Hiển thị danh sách session
        return Scaffold(
          appBar: AppBar(
            backgroundColor: MyTheme.backgroundcolor,
            title: Text(
              'My Session',
              style: AppTextStyles.appbarText,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.pop();
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  GoRouter.of(context).push('/addSession/${widget.eventId}');
                },
                child: Row(
                  children: [
                    Text(
                      "Add",
                      style: TextStyle(
                          color: MyTheme.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      Icons.add,
                      color: MyTheme.primaryColor,
                    )
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: MyTheme.backgroundcolor,
          body: ListView.builder(
            itemCount: sessionViewModel.sessions.length,
            itemBuilder: (context, index) {
              final session = sessionViewModel.sessions[index];
              return GestureDetector(
                onTap: () {
                  context.push('/session-detail', extra: session);
                },
                child: Card(
                  color: const Color.fromARGB(255, 7, 5, 25),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      session['title'] ?? 'No title',
                      style: AppTextStyles.subheading,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: MyTheme.primaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${formatEventTime(session['start_time'])} - ${formatEventTime(session['end_time'])}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: MyTheme.primaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              session['location'] ?? 'No location',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
