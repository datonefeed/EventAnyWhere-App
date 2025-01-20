import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/event/event_viewmodel.dart';
import '../../../core/theme/my_theme.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventViewModel>(context, listen: false).fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventViewModel>(
      builder: (context, eventViewModel, child) {
        if (eventViewModel.isLoading) {
          return Scaffold(
            appBar: AppBar(title: Text('My Events')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (eventViewModel.errorMessage.isNotEmpty ||
            eventViewModel.events.isEmpty) {
          return Scaffold(
            backgroundColor: MyTheme.backgroundcolor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "My Events",
                style: AppTextStyles.appbarText,
              ),
            ),
            body: Center(
              child: Image.asset('assets/images/no_event_found.png'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: MyTheme.backgroundcolor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "My Events",
              style: AppTextStyles.appbarText,
            ),
          ),
          body: ListView.builder(
            itemCount: eventViewModel.events.length,
            itemBuilder: (context, index) {
              final event = eventViewModel.events[index];
              final eventImage = event['images'] ??
                  'https://quangcaotruyenhinh.com/wp-content/uploads/2021/06/unnamed-1.jpg';

              return GestureDetector(
                onTap: () {
                  GoRouter.of(context).push('/eventManagement/${event['_id']}');
                },
                child: Card(
                  color: const Color.fromARGB(255, 17, 19, 23),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 120,
                            height: 80,
                            child: Image.network(
                              eventImage,
                              fit: BoxFit.fill,
                              loadingBuilder: (context, child, progress) {
                                return progress == null
                                    ? child
                                    : Center(
                                        child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/devday.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['title'] ?? 'Untitled',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    color: Color.fromARGB(255, 244, 139, 94),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    event['date'] ?? 'No date provided',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 138, 138, 138),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: Color.fromARGB(255, 244, 139, 94),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    event['location'] ?? 'No location provided',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 138, 138, 138),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
