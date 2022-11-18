import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbn_app/core/extension/double_extension.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

import '../widgets/drawer.dart';

class LocationHistoryView extends StatefulWidget {
  static const String route = '/location_history';
  const LocationHistoryView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LocationHistoryViewState();
  }
}

class LocationHistoryViewState extends State<LocationHistoryView> {
  List<LatLng> tappedPoints = [];
  bool isVisible = true;
  late final MapController _mapController;
  final LatLng center = LatLng(39.93, 32.835);

  Future<List<LatLng>> getSavedRotation() async {
    final savedLocation = [
      LatLng(39.9179, 32.8627),
      LatLng(39.9213, 32.8506),
      LatLng(39.977982, 32.866909),
      LatLng(39.924480, 32.854633),
      LatLng(39.932373, 32.809860),
    ];
    return tappedPoints = savedLocation;
  }

  @override
  void initState() {
    super.initState();
    getSavedRotation();
    _mapController = MapController();
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      tappedPoints.add(latlng);
    });
  }

  @override
  Widget build(BuildContext context) {
    final markers = List.generate(
      tappedPoints.length,
      (index) => Marker(
        width: 80,
        height: 80,
        point: tappedPoints[index],
        builder: (ctx) => Icon(
          Icons.circle_rounded,
          color: index == 0
              ? Colors.green
              : index == tappedPoints.length - 1
                  ? Colors.red
                  : Colors.orange,
          size: 20,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("LOCATION HISTORY"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _floatingActionButton(),
      body: _body(markers),
      drawer: buildDrawer(context, LocationHistoryView.route),
    );
  }

  Column _body(List<Marker> markers) {
    return Column(
      children: [
        Flexible(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(center: center, zoom: 12.5, onTap: _handleTap),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              isVisible == true
                  ? PolylineLayer(
                      polylines: [
                        Polyline(
                          points: tappedPoints,
                          borderColor: Colors.black,
                          borderStrokeWidth: 3,
                        )
                      ],
                    )
                  : const SizedBox(),
              MarkerLayer(markers: markers),
            ],
          ),
        ),
      ],
    );
  }

  Column _floatingActionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          heroTag: UniqueKey(),
          onPressed: () {
            setState(() {
              tappedPoints.clear();
            });
          },
          label: const Text('Clear All'),
          icon: const Icon(Icons.refresh),
        ),
        0.05.space,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              heroTag: UniqueKey(),
              onPressed: () {
                setState(() {
                  getSavedRotation();
                });
              },
              tooltip: "Used to show saved locations.",
              label: const Text('Get Saved Location'),
              icon: const Icon(Icons.save),
            ),
            FloatingActionButton.extended(
              heroTag: UniqueKey(),
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              tooltip: "Used to hide/show lines between positions.",
              label: const Text('Show/Hide Lines'),
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ],
        ),
        0.05.space,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              heroTag: UniqueKey(),
              onPressed: () {
                setState(() {
                  if (tappedPoints.isNotEmpty) {
                    var deger = tappedPoints.last;
                    tappedPoints = [deger];
                  }
                });
              },
              tooltip:
                  "It is used to delete the rest except the last position.",
              label: const Text('Last Location'),
              icon: const Icon(Icons.delete),
            ),
            FloatingActionButton.extended(
              heroTag: UniqueKey(),
              onPressed: () {
                setState(() {
                  tappedPoints.isNotEmpty
                      ? _mapController.move(tappedPoints.last, 13)
                      : _mapController.move(center, 10);
                });
              },
              label: const Text('Focus Last Location'),
              icon: const Icon(Icons.center_focus_strong),
            ),
          ],
        ),
      ],
    );
  }
}
