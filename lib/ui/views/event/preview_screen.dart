import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/ui/viewmodels/event/event_viewmodel.dart';

class PreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "3 of 4: Preview",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: MyTheme.backgroundcolor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: Container(
        color: MyTheme.backgroundcolor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressBar(),
            const SizedBox(height: 16),
            _buildEventImage(context, eventViewModel),
            const SizedBox(height: 16),
            _buildEventDetails(eventViewModel),
            const Spacer(),
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 0.75,
        child: Container(
          decoration: BoxDecoration(
            color: MyTheme.primaryColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildEventImage(BuildContext context, EventViewModel eventViewModel) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[800],
          ),
          child: eventViewModel.eventImages.isNotEmpty
              ? Image.file(
                  eventViewModel.eventImages.first,
                  fit: BoxFit.cover,
                )
              : const Center(
                  child: Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => GoRouter.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: MyTheme.primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: const [
                  Icon(Icons.edit, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    "Edit Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetails(EventViewModel eventViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eventViewModel.title ?? "Event Title",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildIconTextRow(
            Icons.calendar_today, eventViewModel.date ?? "Date Not Set"),
        const SizedBox(height: 8),
        _buildIconTextRow(
            Icons.access_time, eventViewModel.time ?? "Time Not Set"),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Icon(Icons.add, color: MyTheme.primaryColor, size: 16),
              const SizedBox(width: 8),
              Text(
                "Add to Calendar",
                style: TextStyle(
                  color: MyTheme.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildIconTextRow(
            Icons.location_on, eventViewModel.location ?? "Location Not Set"),
        const SizedBox(height: 16),
        const Text(
          "Organizer",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          eventViewModel.organizerName ?? "Organizer Not Set",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Event Description",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          eventViewModel.description ??
              "Description Not Set. Please go back and provide details.",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildIconTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 16),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => context.push('/reviewAndSend'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Next: Review & Send",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Image.asset('assets/icons/right_arrow.png')
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyTheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
