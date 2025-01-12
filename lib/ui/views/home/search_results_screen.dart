import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/ui/viewmodels/event/event_search_viewmodel.dart';

class SearchResultsScreen extends StatelessWidget {
  final String keyword;

  const SearchResultsScreen({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EventSearchViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.searchEvents(keyword);
    });

    return Scaffold(
      backgroundColor: MyTheme.backgroundcolor,
      appBar: AppBar(
        backgroundColor: MyTheme.backgroundcolor,
        title: Text('Results for "$keyword"'),
        titleTextStyle: AppTextStyles.appbarText,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Consumer<EventSearchViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                viewModel.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (viewModel.events.isEmpty) {
            return Center(
                child: Image.asset('assets/images/no_event_found.png'));
          } else {
            return ListView.builder(
              itemCount: viewModel.events.length,
              itemBuilder: (context, index) {
                final event = viewModel.events[index];
                final eventImage = event['images'] ??
                    'https://quangcaotruyenhinh.com/wp-content/uploads/2021/06/unnamed-1.jpg';
                return GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push('/event/${event['_id']}');
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 17, 19, 23),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          eventImage.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 120,
                                    height: 80,
                                    child: Image.network(
                                      eventImage,
                                      fit: BoxFit.fill,
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        print('Error loading image: $error');
                                        print('StackTrace: $stackTrace');
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.asset(
                                            'assets/images/devday.png',
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['title'] ?? 'Untitled',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: const Color.fromARGB(
                                          255, 244, 139, 94),
                                      size: 22,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      event['date'] ?? 'No date provided',
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
                                      color: const Color.fromARGB(
                                          255, 244, 139, 94),
                                      size: 22,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      event['location'] ??
                                          'No location provided',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
