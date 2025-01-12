import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/ui/viewmodels/home/home_viewmodel.dart';
import 'package:intl/intl.dart';

class UpcomingListEvent extends StatefulWidget {
  const UpcomingListEvent({Key? key}) : super(key: key);

  @override
  _UpcomingListEventState createState() => _UpcomingListEventState();
}

class _UpcomingListEventState extends State<UpcomingListEvent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text("Events"),
        titleTextStyle: AppTextStyles.appbarText,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 55, vertical: 20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(71, 135, 134, 134),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(71, 135, 134, 134), width: 5),
                color: MyTheme.backgroundcolor,
                borderRadius: BorderRadius.circular(30),
              ),
              labelPadding: const EdgeInsets.symmetric(vertical: 3),
              indicatorWeight: 0,
              dividerColor: Colors.transparent,
              labelColor: MyTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              tabs: const [
                Tab(text: "      UPCOMING       "),
                Tab(text: "    PAST EVENTS    "),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _EventList(isUpcoming: true),
                _EventList(isUpcoming: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventList extends StatelessWidget {
  final bool isUpcoming;

  const _EventList({Key? key, required this.isUpcoming}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (viewModel.errorMessage.isNotEmpty) {
          return Center(
            child: Text("Error: ${viewModel.errorMessage}"),
          );
        }

        // Filter events based on date
        final now = DateTime.now();
        final events = viewModel.eventList.where((event) {
          final eventDate = DateTime.parse(event.date);
          return isUpcoming ? eventDate.isAfter(now) : eventDate.isBefore(now);
        }).toList();

        if (events.isEmpty) {
          return Center(
            child: Text(isUpcoming
                ? "No upcoming events available"
                : "No past events available"),
          );
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              color: const Color.fromARGB(255, 21, 20, 26),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ListTile(
                leading: event.imageUrl != null
                    ? Image.network(
                        event.imageUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.event),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                  child: Text(
                    event.title ?? "No Title",
                    style: TextStyle(
                        fontSize: 20,
                        color: MyTheme.white,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          DateFormat('dd-MM-yyyy hh:mm a').format(
                            DateTime.parse(event.date),
                          ),
                          style: TextStyle(fontSize: 16, color: MyTheme.white),
                        ),
                      ],
                    ),
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
                          event.location ?? "No Location",
                          style: TextStyle(fontSize: 16, color: MyTheme.white),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  GoRouter.of(context).push('/event/${event.id}');
                },
              ),
            );
          },
        );
      },
    );
  }
}
