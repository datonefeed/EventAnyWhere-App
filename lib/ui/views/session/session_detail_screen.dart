import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import '../../viewmodels/session/session_detail_viewmodel.dart';
import 'package:intl/intl.dart';

class MySessionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> session;

  const MySessionDetailScreen({Key? key, required this.session})
      : super(key: key);

  @override
  _SessionDetailScreenState createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<MySessionDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SessionDetailViewModel>(context, listen: false)
          .fetchSpeakers(widget.session['_id']);
    });
  }

  String formatEventTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    final sessionViewModel = Provider.of<SessionDetailViewModel>(context);
    final session = widget.session;

    return Scaffold(
      backgroundColor: MyTheme.backgroundcolor,
      appBar: AppBar(
        backgroundColor: MyTheme.backgroundcolor,
        title: Text(
          'Session Detail',
          overflow: TextOverflow.ellipsis,
        ),
        titleTextStyle: AppTextStyles.appbarText,
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
              context.push('/updateSession', extra: session);
            },
            child: Row(
              children: [
                Text(
                  "Edit",
                  style: TextStyle(
                      color: MyTheme.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 2,
                ),
                Icon(
                  Icons.edit,
                  size: 22,
                  color: MyTheme.primaryColor,
                )
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session['title'],
              style: AppTextStyles.appbarText,
            ),
            const SizedBox(height: 8.0),
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
            const SizedBox(height: 5.0),
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
            const SizedBox(height: 16.0),
            Text(
              session['description'],
              style: TextStyle(fontSize: 16, color: MyTheme.white),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Text('Speaker List',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: MyTheme.white)),
                Spacer(),
                TextButton(
                    onPressed: () {
                      GoRouter.of(context)
                          .push('/addSpeaker/${session['_id']}');
                    },
                    child: Text(
                      'Add',
                      style:
                          TextStyle(fontSize: 18, color: MyTheme.primaryColor),
                    ))
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: sessionViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : sessionViewModel.errorMessage.isNotEmpty
                      ? Center(child: Text(sessionViewModel.errorMessage))
                      : sessionViewModel.speakers.isEmpty
                          ? const Center(child: Text('No speakers found'))
                          : ListView.builder(
                              itemCount: sessionViewModel.speakers.length,
                              itemBuilder: (context, index) {
                                final speakerData =
                                    sessionViewModel.speakers[index];
                                final speaker = speakerData['speaker'];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(speaker['image']),
                                  ),
                                  title: Text(
                                    speaker['name'],
                                    style: TextStyle(
                                        fontSize: 18, color: MyTheme.white),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        speakerData['position'],
                                        style: TextStyle(
                                            fontSize: 16, color: MyTheme.grey),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
