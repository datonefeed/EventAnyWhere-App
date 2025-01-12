import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/ui/widgets/Customs/filter_bottom_sheet.dart';

class CustomSearchContainer extends StatefulWidget {
  const CustomSearchContainer({super.key});

  @override
  State<CustomSearchContainer> createState() => _CustomSearchContainerState();
}

class _CustomSearchContainerState extends State<CustomSearchContainer> {
  final TextEditingController _controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  // Mock suggestion data
  final List<String> _allEvents = [
    'Music Festival',
    'Sports Event',
    'Food Carnival',
    'Tech Conference',
    'Art Exhibition',
    'Book Fair',
    'Music concert',
    'Academy Awards',
    'Art Basel',
    'Asian Games',
    'Berlin Marathon',
    'Burning Man',
    'Bastille Day',
  ];

  void _updateSuggestions(String query) {
    if (query.isNotEmpty) {
      _suggestions = _allEvents
          .where((event) => event.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _showSuggestions = _suggestions.isNotEmpty;
    } else {
      _showSuggestions = false;
      _suggestions.clear();
    }
    _showOrRemoveOverlay();
  }

  void _showOrRemoveOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    if (_showSuggestions) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return const FilterBottomSheet();
      },
    );
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            color: const Color.fromARGB(255, 1, 1, 21),
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _suggestions[index],
                    style: AppTextStyles.subheading,
                  ),
                  onTap: () {
                    _controller.text = _suggestions[index];
                    _removeOverlay();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _showSuggestions = false;
    }
  }

  void _handleOkPressed() {
    // Xử lý khi nhấn OK
    final keyword = _controller.text.trim();
    if (keyword.isNotEmpty) {
      _removeOverlay();
      context.push('/search-results', extra: keyword); // Điều hướng GoRouter
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white),
          Container(
            color: MyTheme.white.withOpacity(0.6),
            width: 1,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              style: AppTextStyles.subheading,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(
                  color: MyTheme.white.withOpacity(0.6),
                  fontSize: 18,
                ),
              ),
              onChanged: (value) => _updateSuggestions(value),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.white),
            onPressed: _handleOkPressed, // Gọi hàm xử lý OK
          ),
          GestureDetector(
            onTap: () => _showFilterSheet(context),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: MyTheme.customLightBlue.withOpacity(1),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                children: [
                  Image(
                    image: AssetImage('assets/icons/ic_filter.png'),
                  ),
                  Text(
                    'Filters',
                    style: TextStyle(color: MyTheme.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
