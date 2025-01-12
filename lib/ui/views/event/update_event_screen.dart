import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/models/event_model.dart';
import 'package:event_any_where_app/ui/viewmodels/event/update_event_viewmodel.dart';

class UpdateEventScreen extends StatefulWidget {
  final EventModel event;

  const UpdateEventScreen({required this.event});

  @override
  _UpdateEventScreenState createState() => _UpdateEventScreenState();
}

class _UpdateEventScreenState extends State<UpdateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _locationController;

  File? _imageFile;
  late String _currentImageUrl;

  String formatDateInput(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate).toLocal();
    String formattedDate = "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}:"
        "${dateTime.second.toString().padLeft(2, '0')} "
        "${dateTime.day.toString().padLeft(2, '0')}-"
        "${dateTime.month.toString().padLeft(2, '0')}-"
        "${dateTime.year}";
    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _dateController =
        TextEditingController(text: formatDateInput(widget.event.date));
    _locationController = TextEditingController(text: widget.event.location);
    _currentImageUrl = widget.event.imageUrl;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UpdateEventViewModel>(context);

    return Scaffold(
      backgroundColor: MyTheme.backgroundcolor,
      appBar: AppBar(
        title: Text('Update Event'),
        titleTextStyle: AppTextStyles.appbarText,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: MyTheme.backgroundcolor,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose your event image",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _imageFile != null
                      ? Image.file(_imageFile!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover)
                      : (_currentImageUrl.isNotEmpty
                          ? Image.network(
                              _currentImageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: Icon(Icons.camera_alt, size: 50),
                            )),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Event Title",
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
                  hintText: "Enter event title",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: MyTheme.backgroundcolor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter event title' : null,
              ),
              SizedBox(height: 16),
              Text(
                "Event Description",
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
                  hintText: "Write your event description",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: MyTheme.backgroundcolor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter event description' : null,
              ),
              SizedBox(height: 16),
              Text(
                "Event Timing",
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
                      _dateController.text = _formatDate(combinedDateTime);
                    }
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: "hh:mm:ss dd-mm-yyyy",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: MyTheme.backgroundcolor,
                      prefixIcon:
                          Icon(Icons.calendar_today, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter event timing' : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Location",
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
                  prefixIcon: Icon(Icons.location_on, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter event location' : null,
              ),
              SizedBox(height: 50),
              viewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await viewModel.updateEvent(
                            id: widget.event.id,
                            title: _titleController.text,
                            description: _descriptionController.text,
                            location: _locationController.text,
                            date: _dateController.text,
                            imagePath: _imageFile?.path,
                          );

                          if (viewModel.errorMessage == null) {
                            final snackBar = SnackBar(
                              content: AwesomeSnackbarContent(
                                title: 'Success!',
                                message: 'Event updated successfully',
                                contentType: ContentType.success,
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(viewModel.errorMessage!),
                            ));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyTheme.primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: AppTextStyles.subheading,
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
}
