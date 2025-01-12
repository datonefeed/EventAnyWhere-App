import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import '../../viewmodels/home/filter_viewmodel.dart';

class FilterContent extends StatefulWidget {
  const FilterContent({super.key});

  @override
  State<FilterContent> createState() => _FilterContentState();
}

class _FilterContentState extends State<FilterContent> {
  // Biến lưu tạm thời bộ lọc
  String tempSelectedLocation = "";
  String tempSelectedTime = "";
  String tempSelectedCategory = "";

  final List<Map<String, dynamic>> categories = [
    {
      "icon": Icons.business_center,
      "label": "Conference",
      "id": "676d4ae94a177ad816042ff3"
    },
    {
      "icon": Icons.handyman,
      "label": "Workshop",
      "id": "676d4ae94a177ad816042ff4"
    },
    {"icon": Icons.event, "label": "Opening", "id": "676d4ae94a177ad816042ff5"},
    {
      "icon": Icons.favorite,
      "label": "Wedding",
      "id": "676d4ae94a177ad816042ff6"
    },
    {
      "icon": Icons.school,
      "label": "Graduation",
      "id": "676d4ae94a177ad816042ff7"
    },
    {
      "icon": Icons.music_note,
      "label": "Music",
      "id": "676d4ae94a177ad816042ff8"
    },
    {"icon": Icons.brush, "label": "Art", "id": "676d4ae94a177ad816042ff9"},
    {
      "icon": Icons.restaurant,
      "label": "Food",
      "id": "676d4ae94a177ad816042ffa"
    },
    {
      "icon": Icons.directions_run,
      "label": "Marathon",
      "id": "676d4ae94a177ad816042ffb"
    },
    {"icon": Icons.sports, "label": "Sports", "id": "676d4ae94a177ad816042ffc"},
    {"icon": Icons.face, "label": "Beauty", "id": "676d4ae94a177ad816042ffd"},
    {
      "icon": Icons.volunteer_activism,
      "label": "Charity",
      "id": "676d4ae94a177ad816042ffe"
    },
    {"icon": Icons.work, "label": "Job Fair", "id": "676d4ae94a177ad816042fff"},
    {
      "icon": Icons.computer,
      "label": "Technology",
      "id": "676d4ae94a177ad816043000"
    },
    {
      "icon": Icons.language,
      "label": "Cultural",
      "id": "676d4ae94a177ad816043001"
    },
    {
      "icon": Icons.more_horiz,
      "label": "Other",
      "id": "676d4ae94a177ad816043002"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 27, 27, 31),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() => tempSelectedCategory = category['id']);
                        },
                        child: _buildCategoryIcon(
                          category['icon'],
                          category['label'],
                          isSelected: tempSelectedCategory == category['id'],
                        ),
                      ),
                      const SizedBox(width: 18), // Khoảng cách giữa các icon
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),

            // Time Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeButton('Today', 'today'),
                _buildTimeButton('Tomorrow', 'tomorrow'),
                _buildTimeButton('This week', 'this_week'),
              ],
            ),
            const SizedBox(height: 30),

            // Location Input
            TextField(
              decoration: InputDecoration(
                hintText: "Location",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.transparent,
                prefixIcon: Icon(Icons.location_on, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (value) => tempSelectedLocation = value,
            ),
            const SizedBox(height: 50),

            // Apply Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Provider.of<FilterViewModel>(context, listen: false)
                    .fetchFilteredEvents(
                  categoryId: tempSelectedCategory,
                  dateOption: tempSelectedTime,
                  location: tempSelectedLocation,
                );
                Navigator.of(context).pop();
              },
              child: Text(
                'APPLY',
                style: AppTextStyles.subheading,
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label,
      {bool isSelected = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: isSelected
              ? MyTheme.primaryColor
              : const Color.fromARGB(255, 255, 255, 255),
          child: Icon(icon,
              size: 30,
              color: isSelected ? Colors.white : MyTheme.primaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildTimeButton(String label, String value) {
    return OutlinedButton(
      onPressed: () => setState(() => tempSelectedTime = value),
      style: OutlinedButton.styleFrom(
        backgroundColor:
            tempSelectedTime == value ? MyTheme.primaryColor : Colors.white,
        foregroundColor:
            tempSelectedTime == value ? Colors.white : Colors.black,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
