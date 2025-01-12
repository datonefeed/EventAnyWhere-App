import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import '../../viewmodels/event/event_viewmodel.dart';

class CustomizeScreen extends StatefulWidget {
  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  final List<File> images = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      setState(() {
        images.add(imageFile);
      });

      Provider.of<EventViewModel>(context, listen: false)
          .eventImages
          .add(imageFile);

      Provider.of<EventViewModel>(context, listen: false).notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "1 of 4: Customize",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: MyTheme.bottomBarBgColor,
                  title: Text(
                    'Confirm',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: MyTheme.white),
                  ),
                  content: Text(
                    'You want to stop creating new events?',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: MyTheme.white),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Đóng dialog và không làm gì
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: MyTheme.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.go('/entryPoint');
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                            color: MyTheme.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        centerTitle: true,
        backgroundColor: MyTheme.backgroundcolor,
        elevation: 0,
      ),
      body: Container(
        color: MyTheme.backgroundcolor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.25,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyTheme.primaryColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Choose photos for your event",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: images.isEmpty
                      ? Center(
                          child: Icon(Icons.add_a_photo,
                              color: Colors.white, size: 50),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            images[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Choose event type",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              DropdownButton<String>(
                value: eventViewModel.selectedCategory,
                hint: Text(
                  'Other',
                  style: TextStyle(color: Colors.white),
                ),
                items: eventViewModel.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['_id'],
                    child: Text(
                      category['name'],
                      style: AppTextStyles.body,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  eventViewModel.updateSelectedCategory(newValue);
                },
                dropdownColor: const Color.fromARGB(255, 10, 11, 22),
                isExpanded: true,
                style: TextStyle(color: MyTheme.backgroundcolor),
                underline: Container(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/eventDetails');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Next: Event Details",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Image.asset('assets/icons/right_arrow.png')
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
