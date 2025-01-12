import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/ui/viewmodels/AI_recommendation/recommend_viewmodel.dart';

class RecommendScreen extends StatelessWidget {
  // Hàm lấy ngày và tháng từ chuỗi "date"
  String getDayAndMonth(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    int day = dateTime.day;
    int month = dateTime.month;
    return "$day \n${_getMonthName(month)}";
  }

  String _getMonthName(int month) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecommendViewModel()..fetchRecommendations(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Event Recommend"),
          titleTextStyle: AppTextStyles.appbarText,
          centerTitle: true,
          backgroundColor: MyTheme.backgroundcolor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
        backgroundColor: MyTheme.backgroundcolor, // Set nền cho giống hình
        body: Consumer<RecommendViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(child: Text("Error: ${viewModel.errorMessage}"));
            }

            if (viewModel.recommendations.isEmpty) {
              return Center(child: Text("No recommendations found."));
            }

            return ListView.builder(
              itemCount: viewModel.recommendations.length,
              itemBuilder: (context, index) {
                final recommendation = viewModel.recommendations[index];
                final eventDetails = recommendation['eventDetails'];

                return InkWell(
                  onTap: () {
                    GoRouter.of(context)
                        .push('/event/${recommendation['event_id']}');
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 30),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 17, 19, 23),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: MyTheme.primaryColor,
                          blurRadius: 8,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              child: Image.network(
                                eventDetails['images'],
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Nhãn "10 Jun"
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 187, 187, 187)
                                          .withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  getDayAndMonth(eventDetails['date']),
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 252, 91, 4),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            // Nút bookmark
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 187, 187, 187)
                                          .withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    size: 30,
                                    fill: 1,
                                    Icons.bookmark_added,
                                    color:
                                        const Color.fromARGB(255, 252, 91, 4),
                                  ),
                                  onPressed: () {
                                    // Thực hiện hành động khi nhấn nút bookmark
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Phần Title và Explanation
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eventDetails['title'] ?? "No Title",
                                style: AppTextStyles.heading,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              // Hiệu ứng đánh máy cho đoạn explanation
                              AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    recommendation['explanation'] ??
                                        "No explanation",
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      color: MyTheme.primaryColor,
                                    ),
                                    speed: const Duration(
                                        milliseconds: 50), // Tốc độ đánh máy
                                  ),
                                ],
                                isRepeatingAnimation: false, // Không lặp lại
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
