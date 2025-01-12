import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import '../../viewmodels/session/session_viewmodel.dart';
import 'package:intl/intl.dart';

class AddSessionScreen extends StatefulWidget {
  final String eventId;

  const AddSessionScreen({required this.eventId});

  @override
  _AddSessionScreenState createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _locationController = TextEditingController();

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

  Future<void> _submit() async {
    if (compareDateTime(_startTimeController.text, _endTimeController.text) ==
        false) {
      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Failure!',
          message: 'End date must be greater than start date!',
          contentType: ContentType.failure,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = Provider.of<SessionViewModel>(context, listen: false);
      final success = await viewModel.createSession(
        eventId: widget.eventId,
        title: _titleController.text,
        description: _descriptionController.text,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        location: _locationController.text,
      );

      if (success) {
        final snackBar = SnackBar(
          content: AwesomeSnackbarContent(
            title: 'Success!',
            message: 'Session added successfully!',
            contentType: ContentType.success,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        context.pop();
      } else {
        final snackBar = SnackBar(
          content: AwesomeSnackbarContent(
            title: 'Failure!',
            message: viewModel.errorMessage!,
            contentType: ContentType.failure,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SessionViewModel>(context);

    return Scaffold(
      backgroundColor: MyTheme.backgroundcolor,
      appBar: AppBar(
        title: Text(
          'Add Session',
          style: AppTextStyles.appbarText,
        ),
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
          child: Form(
            key: _formKey,
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
                TextFormField(
                  controller: _titleController,
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
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Title is required' : null,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Session Description",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
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
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Description is required' : null,
                ),
                SizedBox(
                  height: 10,
                ),
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
                        _startTimeController.text =
                            _formatDate(combinedDateTime);
                      }
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _startTimeController,
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
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Start time is required'
                          : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
                        _endTimeController.text = _formatDate(combinedDateTime);
                      }
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _endTimeController,
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
                      validator: (value) => value?.isEmpty ?? true
                          ? 'End time is required'
                          : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Session Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _locationController,
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
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Location is required' : null,
                ),
                const SizedBox(height: 50),
                viewModel.isLoading
                    ? CircularProgressIndicator()
                    : GestureDetector(
                        onTap: _submit,
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
                                  'Add session',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: MyTheme.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Image(
                                  image: AssetImage(
                                      'assets/icons/right_arrow.png')),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.hour}:${date.minute}:${date.second} ${date.day}-${date.month}-${date.year}';
  }
}
