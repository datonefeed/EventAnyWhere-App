import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/constants/app_routers.dart';
import 'package:event_any_where_app/models/tab_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:event_any_where_app/ui/viewmodels/home/filter_viewmodel.dart';
import 'package:event_any_where_app/ui/widgets/Appbars/custom_app_bar.dart';
import 'package:event_any_where_app/ui/widgets/Customs/custom_search_container.dart';
import 'package:event_any_where_app/ui/widgets/Customs/top_container.dart';
import 'package:event_any_where_app/ui/widgets/cards/event_item.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/models/event_model.dart';
import 'package:event_any_where_app/repositories/event_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventRepository _eventRepository = EventRepository();
  final FilterViewModel _filterViewModel = FilterViewModel();
  List<EventModel> eventList = [];
  bool _isLoading = true;

  final tabItemsList = [
    TabItemModel(
      image: "assets/icons/ic_sports.png",
      title: "Sports",
      backgroundColor: MyTheme.customRed,
    ),
    TabItemModel(
      image: "assets/icons/ic_music.png",
      title: "Music",
      backgroundColor: MyTheme.customYellowWithOrangeShade,
    ),
    TabItemModel(
      image: "assets/icons/ic_food.png",
      title: "Food",
      backgroundColor: MyTheme.foodTabItemColor,
    ),
    TabItemModel(
      image: "assets/icons/ic_art.png",
      title: "Arts",
      backgroundColor: MyTheme.customRed,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });
    // eventList = await _eventRepository.fetchEvents();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FilterViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchFilteredEvents();
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyTheme.backgroundcolor,
      body: Column(
        children: [
          TopContainer(tabItemsList: tabItemsList),
          SizedBox(height: 0),
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Upcoming Events",
                          style: TextStyle(
                              color: MyTheme.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/upcomingEventList');
                        },
                        child: Row(
                          children: [
                            Text(
                              "See All",
                              style: TextStyle(color: MyTheme.grey),
                            ),
                            Icon(
                              Icons.arrow_right,
                              color: MyTheme.grey,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Container(
                //   width: double.infinity,
                //   height: 300,
                //   child: _isLoading
                //       ? Center(child: CircularProgressIndicator())
                //       : ListView.builder(
                //           scrollDirection: Axis.horizontal,
                //           itemBuilder: (ctx, index) {
                //             final eventModel = eventList[index];
                //             return EventItem(eventModel: eventModel);
                //           },
                //           itemCount: eventList.length,
                //           padding: EdgeInsets.symmetric(horizontal: 12),
                //         ),
                // ),
                Container(
                  width: double.infinity,
                  height: 300,
                  child: Consumer<FilterViewModel>(
                    builder: (context, filterViewModel, child) {
                      return filterViewModel.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filterViewModel.eventList.length,
                              itemBuilder: (ctx, index) {
                                final event = filterViewModel.eventList[index];
                                return EventItem(eventModel: event);
                              },
                            );
                    },
                  ),
                ),
                // Invite Your Friends
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 0, 0, 0),
                        Color.fromARGB(255, 39, 38, 38),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "AI suggests events",
                              style: TextStyle(
                                fontSize: 18,
                                color: MyTheme.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Try our suggestion AI now...!",
                                style: TextStyle(color: MyTheme.grey),
                              ),
                            ),
                            SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                context.push('/recommend');
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: MyTheme.inviteButtonColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  child: Text(
                                    "Go Go!",
                                    style: TextStyle(
                                        color: MyTheme.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Image(
                          height: 140,
                          image: AssetImage(
                              'assets/images/img_inviate_your_friend.png'),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Nearby You",
                          style: TextStyle(
                              color: MyTheme.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        "See All",
                        style: TextStyle(color: MyTheme.grey),
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: MyTheme.grey,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TabItemsList extends StatelessWidget {
  const TabItemsList({
    super.key,
    required this.tabItemsList,
  });

  final List<TabItemModel> tabItemsList;

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    return Container(
      height: 40,
      // width: double.infinity,
      width: query.size.width,
      margin: EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {
          final item = tabItemsList[index];
          return TabItem(
            image: item.image,
            title: item.title,
            backgroundColor: item.backgroundColor,
          );
        },
        itemCount: tabItemsList.length,
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  String image;
  String title;
  Color backgroundColor;
  TabItem({
    super.key,
    required this.image,
    required this.title,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        color: backgroundColor,
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage('$image'),
          ),
          SizedBox(width: 8),
          Text(
            "$title",
            style: TextStyle(color: MyTheme.white, fontSize: 18),
          )
        ],
      ),
    );
  }
}
