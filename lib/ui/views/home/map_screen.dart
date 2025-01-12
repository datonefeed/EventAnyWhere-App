import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';

import '../../../repositories/test data/mock_events.dart';

class EventMapScreen extends StatefulWidget {
  @override
  _EventMapScreenState createState() => _EventMapScreenState();
}

class _EventMapScreenState extends State<EventMapScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 7.0;
  LatLng _currentCenter = LatLng(16.0680, 108.2300);

  void _zoomToDuyTan() {
    const LatLng targetLocation = LatLng(16.0741, 108.1500);
    const double targetZoom = 15.0;
    const int steps = 200;
    const Duration stepDuration = Duration(milliseconds: 5);

    LatLng currentCenter = _currentCenter;
    double currentZoom = _currentZoom;

    double stepLat = (targetLocation.latitude - currentCenter.latitude) / steps;
    double stepLng =
        (targetLocation.longitude - currentCenter.longitude) / steps;
    double stepZoom = (targetZoom - currentZoom) / steps;

    for (int i = 1; i <= steps; i++) {
      Timer(stepDuration * i, () {
        if (mounted) {
          setState(() {
            _currentCenter = LatLng(
              currentCenter.latitude + stepLat * i,
              currentCenter.longitude + stepLng * i,
            );
            _currentZoom = currentZoom + stepZoom * i;

            _mapController.move(_currentCenter, _currentZoom);
          });
        }
      });
    }

    // Hiển thị thông báo khi hoàn thành
    Timer(stepDuration * steps, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("vị trí của bạn"),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  void _showEventDetails(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          color: const Color.fromARGB(255, 1, 5, 23),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  event['image'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                event['title'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                event['description'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, color: MyTheme.primaryColor),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      event['location'],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_today, color: MyTheme.primaryColor),
                  SizedBox(width: 5),
                  Text(
                    event['date'],
                    style: TextStyle(fontSize: 16, color: MyTheme.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(color: MyTheme.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.backgroundcolor,
        title: Text('Event Map'),
        titleTextStyle: AppTextStyles.appbarText,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: _currentZoom,
              onPositionChanged: (position, _) {
                setState(() {
                  _currentCenter = position.center!;
                  _currentZoom = position.zoom!;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
                subdomains: ['a', 'b', 'c', 'd'],
              ),
              MarkerLayer(
                markers: [
                  ...mockEvents.map((event) {
                    return Marker(
                      width: 100.0,
                      height: 100.0,
                      point: LatLng(event['latitude'], event['longitude']),
                      child: GestureDetector(
                        onTap: () => _showEventDetails(event),
                        child: Icon(
                          Icons.location_on,
                          color: const Color.fromARGB(255, 189, 80, 2),
                          size: 50.0,
                        ),
                      ),
                    );
                  }).toList(),
                  Marker(
                    width: 100.0,
                    height: 100.0,
                    point: LatLng(16.0741, 108.1500),
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Đại học Duy Tân - Hòa Khánh Nam"),
                        ));
                      },
                      child: Icon(
                        Icons.location_on,
                        color: const Color.fromARGB(255, 243, 61, 33),
                        size: 50.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 120,
            right: 20,
            child: ElevatedButton(
              onPressed: _zoomToDuyTan,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.primaryColor,
                shape: CircleBorder(),
                padding: EdgeInsets.all(15),
              ),
              child: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
