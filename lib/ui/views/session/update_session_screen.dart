import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/ui/viewmodels/session/update_session_viewmodel.dart';
import 'package:intl/intl.dart';

class UpdateSessionScreen extends StatefulWidget {
  final Map<String, dynamic> session;

  UpdateSessionScreen({required this.session});

  @override
  _UpdateSessionScreenState createState() => _UpdateSessionScreenState();
}

class _UpdateSessionScreenState extends State<UpdateSessionScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startTimingController = TextEditingController();
  final TextEditingController endTimingController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String convertDateTime(String inputDateTime) {
    try {
      DateTime dateTime = DateTime.parse(inputDateTime);
      String formattedDateTime =
          DateFormat('HH:mm:ss dd-MM-yyyy').format(dateTime);
      return formattedDateTime;
    } catch (e) {
      return "Invalid Date Format";
    }
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.session['title'] ?? '';
    descriptionController.text = widget.session['description'] ?? '';
    startTimingController.text =
        convertDateTime(widget.session['start_time']) ?? '';
    endTimingController.text =
        convertDateTime(widget.session['end_time']) ?? '';
    locationController.text = widget.session['location'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final sessionViewModel = Provider.of<UpdateSessionViewmodel>(context);

    return Scaffold(
      backgroundColor: MyTheme.backgroundcolor,
      appBar: AppBar(
        title: Text('Update Session'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Session Title",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: MyTheme.backgroundcolor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Session Description",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write your session description",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: MyTheme.backgroundcolor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Session Start Time",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final themeData = Theme.of(context);
                  final customTheme = themeData.copyWith(
                    primaryColor: MyTheme.primaryColor,
                    colorScheme:
                        ColorScheme.light(primary: MyTheme.primaryColor),
                  );

                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                    builder: (context, child) {
                      return Theme(
                        data: customTheme,
                        child: child!,
                      );
                    },
                  );

                  if (selectedDate != null) {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                      builder: (context, child) {
                        return Theme(
                          data: customTheme,
                          child: child!,
                        );
                      },
                    );

                    if (selectedTime != null) {
                      final combinedDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      startTimingController.text =
                          _formatDate(combinedDateTime);
                    }
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: startTimingController,
                    decoration: InputDecoration(
                      hintText: "Start Time",
                      prefixIcon: Icon(Icons.access_time, color: Colors.grey),
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: MyTheme.backgroundcolor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Session End Time",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final themeData = Theme.of(context);
                  final customTheme = themeData.copyWith(
                    primaryColor: MyTheme.primaryColor,
                    colorScheme:
                        ColorScheme.light(primary: MyTheme.primaryColor),
                  );

                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                    builder: (context, child) {
                      return Theme(
                        data: customTheme,
                        child: child!,
                      );
                    },
                  );

                  if (selectedDate != null) {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                      builder: (context, child) {
                        return Theme(
                          data: customTheme,
                          child: child!,
                        );
                      },
                    );

                    if (selectedTime != null) {
                      final combinedDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      endTimingController.text = _formatDate(combinedDateTime);
                    }
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: endTimingController,
                    decoration: InputDecoration(
                      hintText: "End Time",
                      prefixIcon: Icon(Icons.access_time, color: Colors.grey),
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: MyTheme.backgroundcolor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Session Location",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: "Location",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: MyTheme.backgroundcolor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 32),
              sessionViewModel.isLoading
                  ? CircularProgressIndicator()
                  : GestureDetector(
                      onTap: () async {
                        final title = titleController.text.trim();
                        final description = descriptionController.text.trim();
                        final startTime = startTimingController.text.trim();
                        final endTime = endTimingController.text.trim();
                        final location = locationController.text.trim();

                        await sessionViewModel.updateSession(
                          sessionId: widget.session['_id'],
                          title: title,
                          description: description,
                          startTime: startTime,
                          endTime: endTime,
                          location: location,
                        );

                        if (title.isEmpty ||
                            description.isEmpty ||
                            startTime.isEmpty ||
                            endTime.isEmpty ||
                            location.isEmpty) {
                          final snackBar = SnackBar(
                            content: AwesomeSnackbarContent(
                              title: 'Warning!',
                              message: 'Please fill on the Field!',
                              contentType: ContentType.warning,
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }

                        if (compareDateTime(startTime, endTime) == false) {
                          final snackBar = SnackBar(
                            content: AwesomeSnackbarContent(
                              title: 'Failure!',
                              message:
                                  'End date must be greater than start date!',
                              contentType: ContentType.failure,
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }

                        if (sessionViewModel.errorMessage != null) {
                          final snackBar = SnackBar(
                            content: AwesomeSnackbarContent(
                              title: 'Failure!',
                              message: sessionViewModel.errorMessage!,
                              contentType: ContentType.failure,
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          final snackBar = SnackBar(
                            content: AwesomeSnackbarContent(
                              title: 'Success!',
                              message: 'Session updated successfully!',
                              contentType: ContentType.success,
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          context.pop();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        margin: const EdgeInsets.symmetric(horizontal: 46),
                        decoration: BoxDecoration(
                          color: MyTheme.primaryColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 30),
                            Expanded(
                              child: Text(
                                'Save',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: MyTheme.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Image(
                                image:
                                    AssetImage('assets/icons/right_arrow.png')),
                            const SizedBox(width: 12),
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

  String _formatDate(DateTime date) {
    return '${date.hour}:${date.minute}:${date.second} ${date.day}-${date.month}-${date.year}';
  }

  bool compareDateTime(String start, String end) {
    try {
      DateFormat format = DateFormat('HH:mm:ss dd-MM-yyyy');
      DateTime startDateTime = format.parse(start);
      DateTime endDateTime = format.parse(end);
      return endDateTime.isAfter(startDateTime) ||
          endDateTime.isAtSameMomentAs(startDateTime);
    } catch (e) {
      print('Invalid date format: $e');
      return false;
    }
  }
}
